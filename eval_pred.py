import random
import pandas as pd
from pylev import levenshtein

# Format sql strings using sqlglot.
# Add one (or two) more variant of baseline: using template + randomly replacing placeholders with recommended values.

def compute_avg_distance(df, print_info=False):
    distances = []
    for row in df.itertuples():
        words = str(row.pred).lower().split()
        target_words = row.target.lower().split()
        distance = levenshtein(words, target_words)  # / len(target_words)
        distances.append(distance)

        # if distance > 500:
        #     print(f'Row {row.Index}: {row.pred}')
        #     print(f'Row {row.Index}: {row.target}')

    avg_distance = sum(distances) / len(distances)

    if print_info:
        print(f'Distances: {distances}')

    return avg_distance


def template_based(test_path, template_path, seq_path, replace_placeholders=True):
    df_test = pd.read_csv(test_path, sep='\t', header=None, names=['source', 'target'])
    df_template = pd.read_csv(template_path)
    df_seq = pd.read_csv(seq_path)

    df = df_test.copy()

    templates = []
    temp_idx = 0
    for i, row in df_seq.iterrows():
        template_row = df_template.iloc[[i - temp_idx]]
        # TPC-DS has many missing rows.
        if template_row['source'].item() == row['source']:
            templates.append(template_row['pred'].item())
        else:
            templates.append('')
            temp_idx += 1

    random.seed(1)
    preds = []
    cnt_replaced = 0
    for template, seq in zip(templates, df_seq['pred']):
        recommendations = seq.split()
        pred = template
        if replace_placeholders:
            replaced = [token if token not in ['UNK'] else random.choice(recommendations) for token in pred.split()]
            cnt_replaced += sum(1 for token in pred.split() if token in ['UNK'])
            pred = ' '.join(replaced)
        preds.append(pred)
    
    print(f'Number of replaced tokens: {cnt_replaced}')
    df['pred'] = preds
    return df


if __name__ == '__main__':
    # df = pd.read_csv('result/seq_predictions_template.csv')
    # for template in df['pred']:
    #     tokens = template.split()
    #     idxs = [i for i, token in enumerate(tokens) if token == '[PH]']
    #     for idx in idxs:
    #         start = max(0, idx - 2)
    #         end = min(len(tokens), idx + 2)
    #         print(' '.join(tokens[start:end]))
    df = pd.read_csv('seq_predictions_filled.csv')
    # df = template_based('tpcds/baseline/seq/test.txt', 'result/baseline_template_predictions_tpcds.csv', 'result/baseline_seq_predictions_tpcds.csv', replace_placeholders=True)
    avg_distance = compute_avg_distance(df, print_info=True)
    print(f'Average distance: {avg_distance}')

    print()