import itertools
import random
from collections import Counter

import pandas as pd
from eval_pred import compute_avg_distance
from template_finder import QueryClusterer, split_sql

import math
from typing import Tuple

import torch
from torch import nn, Tensor
from torch.nn import TransformerEncoder, TransformerEncoderLayer

import copy
import time

from torchtext.data.utils import get_tokenizer
from torchtext.vocab import build_vocab_from_iterator
import torchtext.vocab


def load_data(dirpath, nr_instances=None):
    if nr_instances:
        dirpath += f'/n{nr_instances}'
    data_types = ['train', 'val', 'test']
    type2data = {}
    for data_type in data_types:
        sqls_w_report_id = []
        with open(f'{dirpath}/report_sqls_{data_type}.tsv', 'r') as f:
            for line in f:
                report_id, sql = line.strip().split('\t')
                sqls_w_report_id.append((int(report_id), sql))
        type2data[data_type] = sqls_w_report_id
    return type2data


start_clustering = time.time()

type2data = load_data('tpcds/split')
print(type2data['train'][0])
clusterer = QueryClusterer(type2data['train'])

clusterer.cluster_by_levenshtein(max_ratio=0.05)  # 0.05 for oracle1, oracle2, tpcds

clusterer.init_cluster_ids()

time_clustering = time.time() - start_clustering

nr_reports = len(set(sig.meta.report_id for sig in clusterer.all_sigs))
print(f'nr_reports: {nr_reports}')
print('Less than the number of reports:')
for cid, (template, cluster) in enumerate(clusterer.clusters.items()):
    if len(cluster) < nr_reports:
        print(f'{len(cluster)}\t{cid+1}\t{template}')
print('More than the number of reports:')
for cid, (template, cluster) in enumerate(clusterer.clusters.items()):
    if len(cluster) > nr_reports:
        print(f'{len(cluster)}\t{cid+1}\t{template}')


rid2sqls = {}
for data_type in ['train', 'val', 'test']:
    for report_id, sql in type2data[data_type]:
        rid2sqls.setdefault(report_id, []).append(sql)

type2rid2etids = {}
for data_type in ['train', 'val']:
    rid2etids = {}
    if data_type == 'train':
        for sig in clusterer.all_sigs:
            rid2etids.setdefault(sig.meta.report_id, []).append(sig.meta.estimated_template_id)
    else:
        for report_id, sql in type2data[data_type]:
            rid2etids.setdefault(report_id, []).append(clusterer.find_closest_cluster_id(sql))
    type2rid2etids[data_type] = rid2etids

start_cluster_inference = time.time()
for data_type in ['test']:
    rid2etids = {}
    if data_type == 'train':
        for sig in clusterer.all_sigs:
            rid2etids.setdefault(sig.meta.report_id, []).append(sig.meta.estimated_template_id)
    else:
        for report_id, sql in type2data[data_type]:
            rid2etids.setdefault(report_id, []).append(clusterer.find_closest_cluster_id(sql))
    type2rid2etids[data_type] = rid2etids
time_cluster_inference = time.time() - start_cluster_inference


class TransformerModel(nn.Module):
    def __init__(self, ntoken: int, d_model: int, nhead: int, d_hid: int,
                 nlayers: int, dropout: float = 0.5):
        super().__init__()
        self.model_type = 'Transformer'
        self.pos_encoder = PositionalEncoding(d_model, dropout)
        encoder_layers = TransformerEncoderLayer(d_model, nhead, d_hid, dropout)
        self.transformer_encoder = TransformerEncoder(encoder_layers, nlayers)
        self.encoder = nn.Embedding(ntoken, d_model)
        self.d_model = d_model
        self.decoder = nn.Linear(d_model, ntoken)

        self.init_weights()

    def init_weights(self) -> None:
        initrange = 0.1
        self.encoder.weight.data.uniform_(-initrange, initrange)
        self.decoder.bias.data.zero_()
        self.decoder.weight.data.uniform_(-initrange, initrange)

    def forward(self, src: Tensor, src_mask: Tensor) -> Tensor:
        src = self.encoder(src) * math.sqrt(self.d_model)
        src = self.pos_encoder(src)
        output = self.transformer_encoder(src, src_mask)
        output = self.decoder(output)
        return output


def generate_square_subsequent_mask(sz: int) -> Tensor:
    return torch.triu(torch.ones(sz, sz) * float('-inf'), diagonal=1)


class PositionalEncoding(nn.Module):
    def __init__(self, d_model: int, dropout: float = 0.1, max_len: int = 5000):
        super().__init__()
        self.dropout = nn.Dropout(p=dropout)

        position = torch.arange(max_len).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2) * (-math.log(10000.0) / d_model))
        pe = torch.zeros(max_len, 1, d_model)
        pe[:, 0, 0::2] = torch.sin(position * div_term)
        pe[:, 0, 1::2] = torch.cos(position * div_term)
        self.register_buffer('pe', pe)

    def forward(self, x: Tensor) -> Tensor:
        x = x + self.pe[:x.size(0)]
        return self.dropout(x)


def data_process(raw_text_iter) -> Tensor:
    data = [torch.tensor(vocab(tokenizer(item)), dtype=torch.long) for item in raw_text_iter]
    return torch.cat(tuple(filter(lambda t: t.numel() > 0, data)))


def batchify(data: Tensor, bsz: int) -> Tensor:
    seq_len = data.size(0) // bsz
    data = data[:seq_len * bsz]
    data = data.view(bsz, seq_len).t().contiguous()
    return data.to(device)


def get_batch(source: Tensor, i: int) -> Tuple[Tensor, Tensor]:
    seq_len = min(bptt, len(source) - 1 - i)
    data = source[i:i+seq_len]
    target = source[i+1:i+1+seq_len].reshape(-1)
    return data, target

def train(model: nn.Module) -> None:
    model.train()  # turn on train mode
    total_loss = 0.
    log_interval = 200
    start_time = time.time()
    src_mask = generate_square_subsequent_mask(bptt).to(device)

    num_batches = len(train_data) // bptt
    for batch, i in enumerate(range(0, train_data.size(0) - 1, bptt)):
        data, targets = get_batch(train_data, i)
        seq_len = data.size(0)
        if seq_len != bptt:  # only on last batch
            src_mask = src_mask[:seq_len, :seq_len]
        output = model(data, src_mask)
        loss = criterion(output.view(-1, ntokens), targets)

        optimizer.zero_grad()
        loss.backward()
        torch.nn.utils.clip_grad_norm_(model.parameters(), 0.5)
        optimizer.step()

        total_loss += loss.item()
        if batch % log_interval == 0 and batch > 0:
            lr = scheduler.get_last_lr()[0]
            ms_per_batch = (time.time() - start_time) * 1000 / log_interval
            cur_loss = total_loss / log_interval
            ppl = math.exp(cur_loss)
            print(f'| epoch {epoch:3d} | {batch:5d}/{num_batches:5d} batches | '
                f'lr {lr:02.2f} | ms/batch {ms_per_batch:5.2f} | '
                f'loss {cur_loss:5.2f} | ppl {ppl:8.2f}')
            total_loss = 0
            start_time = time.time()


def evaluate(model: nn.Module, eval_data: Tensor) -> float:
    model.eval()  # turn on evaluation mode
    total_loss = 0.
    src_mask = generate_square_subsequent_mask(bptt).to(device)
    with torch.no_grad():
        for i in range(0, eval_data.size(0) - 1, bptt):
            data, targets = get_batch(eval_data, i)
            seq_len = data.size(0)
            if seq_len != bptt:
                src_mask = src_mask[:seq_len, :seq_len]
            output = model(data, src_mask)
            output_flat = output.view(-1, ntokens)
            total_loss += seq_len * criterion(output_flat, targets).item()
    return total_loss / (len(eval_data) - 1)


def evaluate_test(model: nn.Module, test_seqs):
    model.eval()  # turn on evaluation mode
    # total_loss = 0.
    nr_total = 0
    nr_correct = 0
    len2cnt = {}
    len2correct = {}
    all_probs = []
    corrects = []
    all_preds = []
    all_targets = []
    with torch.no_grad():
        for seq in test_seqs:
            seq_flat = data_process([seq])
            seq_data = seq_flat.unsqueeze(1)
            data = seq_data[:len(seq_data) - 1]
            targets = seq_data[1:].reshape(-1)
            src_mask = generate_square_subsequent_mask(len(seq_data) - 1).to(device)
            output = model(data, src_mask)
            output_flat = output.view(-1, ntokens)
            # total_loss += data.size(0) * criterion(output_flat, targets).item()
            # Compute accuracy.
            probs, predicted = output_flat.softmax(1).max(1)
            all_preds.extend(predicted.tolist())
            all_targets.extend(targets.tolist())
            # print(f'Predicted: {predicted}')
            # print(f'Targets: {targets}')
            all_probs.extend(probs)
            corrects.extend((predicted == targets).tolist())
            nr_correct += sum(predicted == targets).item()
            nr_total += len(targets)
            for idx in range(len(targets)):
                prefix_len = idx + 1
                len2cnt[prefix_len] = len2cnt.get(prefix_len, 0) + 1
                if predicted[idx] == targets[idx]:
                    len2correct[prefix_len] = len2correct.get(prefix_len, 0) + 1
    info_accuracy = f'accuracy: {nr_correct/nr_total:5.2f} ({nr_correct}/{nr_total})'
    print(info_accuracy)
    return len2cnt, len2correct, all_probs, corrects, all_preds, all_targets, info_accuracy
    # return total_loss / (len(eval_data) - 1)


def evaluate_test_fill(model: nn.Module, sqls_test, templates_test):
    model.eval()  # turn on evaluation mode
    # total_loss = 0.
    nr_total = 0
    nr_correct = 0
    len2cnt = {}
    len2correct = {}
    all_probs = []
    corrects = []
    all_preds = []
    all_targets = []
    all_pred_queries = []
    vocab_itos = vocab.get_itos()
    with torch.no_grad():
        for seq_idx, (seq, template) in enumerate(zip(sqls_test, templates_test)):
            idxs_target = [idx - 1 for idx, token in enumerate(template.split()) if token == '[PH]']
            if len(idxs_target) == 0:
                all_pred_queries.append(template)
            else:
                seq_flat = data_process([template])
                seq_data = seq_flat.unsqueeze(1)
                data = seq_data[:-1]
                src_mask = generate_square_subsequent_mask(len(seq_data) - 1).to(device)
                output = model(data, src_mask)
                output_flat = output.view(-1, ntokens)
                # total_loss += data.size(0) * criterion(output_flat, targets).item()
                # Compute accuracy.
                probs, predicted_temp = output_flat.softmax(1).max(1)

                target_seq_flat = data_process(seq)
                target_seq_data = target_seq_flat.unsqueeze(1)
                targets_temp = target_seq_data[1:].reshape(-1)

                # print(seq)
                # print(template)
                # print(idxs_target)
                # print(len(seq.split()))
                # print(len(template.split()))
                # print(len(targets_temp))
                # print(len(predicted_temp))
                # if len(predicted_temp) + 1 != len(template.split()):
                #     print(template)
                #     print(predicted_temp)

                tokens_template = template.split()
                for token_idx in idxs_target:
                    tokens_template[token_idx + 1] = vocab_itos[predicted_temp[token_idx].item()]

                all_pred_queries.append(' '.join(tokens_template))

                if len(predicted_temp) > len(targets_temp):
                    idxs_target = [idx for idx in idxs_target if idx < len(targets_temp)]
                targets = targets_temp[idxs_target]
                predicted = predicted_temp[idxs_target]

                idxs_notunk = [idx for idx, target in enumerate(targets) if target != 0]
                targets = targets[idxs_notunk]
                predicted = predicted[idxs_notunk]

                all_preds.extend(predicted.tolist())
                all_targets.extend(targets.tolist())
                # print(f'Predicted: {predicted}')
                # print(f'Targets: {targets}')
                all_probs.extend(probs)
                corrects.extend((predicted == targets).tolist())
                nr_correct += sum(predicted == targets)
                nr_total += len(targets)
                for idx in range(len(targets)):
                    prefix_len = idx + 1
                    len2cnt[prefix_len] = len2cnt.get(prefix_len, 0) + 1
                    if predicted[idx] == targets[idx]:
                        len2correct[prefix_len] = len2correct.get(prefix_len, 0) + 1
    print(f'accuracy: {(nr_correct/nr_total if nr_total != 0 else 0):5.2f} ({nr_correct}/{nr_total})')
    return len2cnt, len2correct, all_probs, corrects, all_preds, all_targets, all_pred_queries

start_training_template = time.time()

max_etid = max(etid for etids in type2rid2etids['train'].values() for etid in etids)

type2seqs_w_rid = {}
for data_type in ['train', 'val', 'test']:
    type2seqs_w_rid[data_type] = list((rid, ' '.join(str(etid) for etid in etids)) for rid, etids in type2rid2etids[data_type].items())

type2seqs = {}
type2rids = {}
for data_type in ['train', 'val', 'test']:
    seqs_w_rid = list((rid, ' '.join(str(etid) for etid in etids)) for rid, etids in type2rid2etids[data_type].items())
    type2seqs[data_type] = [seq for _, seq in seqs_w_rid]
    type2rids[data_type] = [rid for rid, _ in seqs_w_rid]
    for rid, seq in seqs_w_rid:
        print(f'{data_type} {rid}: {seq}')

train_rids = type2rids['train']
val_rids = type2rids['val']
test_rids = type2rids['test']

# Add special token after each sequence.
train_seqs = [seq + ' <unk>' for seq in type2seqs['train']]
val_seqs = [seq + ' <unk>' for seq in type2seqs['val']]
test_seqs = [seq + ' <unk>' for seq in type2seqs['test']]

tokenizer = get_tokenizer(None)
freq_dict = {str(etid): 1 for etid in range(1, max_etid + 1)}
vocab = torchtext.vocab.vocab(freq_dict, specials=['<unk>'])
# vocab = build_vocab_from_iterator(map(tokenizer, train_seqs), specials=['<unk>'])
vocab.set_default_index(vocab['<unk>'])

train_data_flat = data_process(train_seqs)
val_data_flat = data_process(val_seqs)
test_data_flat = data_process(test_seqs)

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

batch_size = 1  # 20
eval_batch_size = 1  # 10
train_data = batchify(train_data_flat, batch_size)  # shape [seq_len, batch_size]
val_data = batchify(val_data_flat, eval_batch_size)
test_data = batchify(test_data_flat, eval_batch_size)

bptt = 35

ntokens = len(vocab)
emsize = 200
d_hid = 200
nlayers = 3
nhead = 2 
dropout = 0
model = TransformerModel(ntokens, emsize, nhead, d_hid, nlayers, dropout).to(device)

criterion = nn.CrossEntropyLoss()
lr = 1
optimizer = torch.optim.SGD(model.parameters(), lr=lr)
scheduler = torch.optim.lr_scheduler.StepLR(optimizer, 1.0, gamma=0.95)  # gamma=0.95)

best_val_loss = float('inf')
epochs = 50  # 100
best_model = None

for epoch in range(1, epochs + 1):
    epoch_start_time = time.time()
    train(model)
    val_loss = evaluate(model, val_data)
    val_ppl = math.exp(val_loss)
    elapsed = time.time() - epoch_start_time
    print('-' * 89)
    print(f'| end of epoch {epoch:3d} | time: {elapsed:5.2f}s | '
          f'valid loss {val_loss:5.2f} | valid ppl {val_ppl:8.2f}')
    print('-' * 89)

    if val_loss < best_val_loss:
        best_val_loss = val_loss
        best_model = copy.deepcopy(model)

    scheduler.step()
time_training_template = time.time() - start_training_template

start_inference_template = time.time()
len2cnt, len2correct, probs, corrects, all_preds, all_targets, info_accuracy = evaluate_test(best_model, test_seqs)
time_inference_template = time.time() - start_inference_template
print(f'Test rids: {test_rids}')
print(f'Preds: {all_preds}')
print(f'Targets: {all_targets}')
templates_pred = [clusterer.cid2template[etid] if etid != 0 else "" for etid, etid_target in zip(all_preds, all_targets) if etid_target != 0]
sqls_target = [sql for rid in test_rids for sid, sql in enumerate(rid2sqls[rid]) if sid != 0]
print(len(templates_pred))
print(len(sqls_target))

df = pd.DataFrame({
    'target': sqls_target,
    'pred': templates_pred
})
# df.to_csv('seq_predictions.csv', index=False)
avg_distance_template = compute_avg_distance(df, print_info=True)

# for prefix_len, nr_total in sorted(len2cnt.items()):
#     nr_correct = len2correct.get(prefix_len, 0)
#     print(f'Accuracy per prefix length: {prefix_len} {nr_correct} {nr_total} {100 * nr_correct / nr_total}')

# Train a transformer for token prediction.
start_training_token = time.time()

sqls_train = [sql for rid in train_rids for sid, sql in enumerate(rid2sqls[rid])]
sqls_val = [sql for rid in val_rids for sid, sql in enumerate(rid2sqls[rid])]
sqls_test = [sql for rid in test_rids for sid, sql in enumerate(rid2sqls[rid]) if sid != 0]

train_sql_seqs = [seq + ' <unk>' for seq in sqls_train]
val_sql_seqs = [seq + ' <unk>' for seq in sqls_val]
test_sql_seqs = [seq + ' <unk>' for seq in sqls_test]

tokenizer = get_tokenizer(None)
vocab = build_vocab_from_iterator(map(tokenizer, train_sql_seqs), specials=['<unk>'])
vocab.set_default_index(vocab['<unk>'])

train_data_flat = data_process(train_sql_seqs)
val_data_flat = data_process(val_sql_seqs)
test_data_flat = data_process(test_sql_seqs)

batch_size = 20  # 20
eval_batch_size = 10  # 10

train_data = batchify(train_data_flat, batch_size)
val_data = batchify(val_data_flat, eval_batch_size)
test_data = batchify(test_data_flat, eval_batch_size)

ntokens = len(vocab)
model = TransformerModel(ntokens, emsize, nhead, d_hid, nlayers, dropout).to(device)

criterion = nn.CrossEntropyLoss()
lr = 1
optimizer = torch.optim.SGD(model.parameters(), lr=lr)
scheduler = torch.optim.lr_scheduler.StepLR(optimizer, 1.0, gamma=0.95)  # gamma=0.95)

best_val_loss = float('inf')
epochs = 50
best_model = None

for epoch in range(1, epochs + 1):
    epoch_start_time = time.time()
    train(model)
    val_loss = evaluate(model, val_data)
    val_ppl = math.exp(val_loss)
    elapsed = time.time() - epoch_start_time
    print('-' * 89)
    print(f'| end of epoch {epoch:3d} | time: {elapsed:5.2f}s | '
          f'valid loss {val_loss:5.2f} | valid ppl {val_ppl:8.2f}')
    print('-' * 89)

    if val_loss < best_val_loss:
        best_val_loss = val_loss
        best_model = copy.deepcopy(model)

    scheduler.step()
time_training_token = time.time() - start_training_token


templates_test = [clusterer.cid2template[int(etid)] for seq in test_seqs for etid in seq.split()[1:-1]]
_, _, _, _, fill_preds, fill_targets, _ = evaluate_test_fill(best_model, test_sql_seqs, templates_test)
print(f'Preds: {fill_preds}')
print(f'Targets: {fill_targets}')
vocab_itos = vocab.get_itos()
print(f'PRED TARGET')
for pred_idx, target_idx in zip(fill_preds, fill_targets):
    if pred_idx == target_idx:
        print(f'{pred_idx == target_idx}\t{vocab_itos[pred_idx]}\t{vocab_itos[target_idx]}')
for pred_idx, target_idx in zip(fill_preds, fill_targets):
    if pred_idx != target_idx:
        print(f'{pred_idx == target_idx}\t{vocab_itos[pred_idx]}\t{vocab_itos[target_idx]}')

start_inference_token = time.time()
_, _, _, _, _, _, all_pred_queries = evaluate_test_fill(best_model, test_sql_seqs, templates_pred)
time_inference_token = time.time() - start_inference_token
# print(len(all_pred_queries))
# print(len(sqls_target))
df = pd.DataFrame({
    'target': sqls_target,
    'pred': all_pred_queries
})
df.to_csv('seq_predictions_filled.csv', index=False)

print(info_accuracy)
print(f'Average distance (Template only): {avg_distance_template}')
avg_distance = compute_avg_distance(df, print_info=True)
print(f'Average distance: {avg_distance}')
print(f'Number of clusters: {len(clusterer.clusters)}')
print(f'Number of training queries: {len(clusterer.all_sigs)}')
time_training = time_clustering + time_training_template + time_training_token
print(f'Training time (total clustering template token): {time_training} {time_clustering} {time_training_template} {time_training_token}')
time_inference = time_cluster_inference + time_inference_template + time_inference_token
print(f'Inference time (total clustering template token): {time_inference} {time_cluster_inference} {time_inference_template} {time_inference_token}')
