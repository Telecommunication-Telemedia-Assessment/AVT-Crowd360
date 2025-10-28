import pandas as pd
import json

data = pd.read_csv('_ratings.csv')

# Function to parse JSON and extract filename
def extract_filename(json_str):
    try:
        if isinstance(json_str, str):
            parsed_json = json.loads(json_str)
            if isinstance(parsed_json, dict) and 'filename' in parsed_json:
                return parsed_json['filename']
    except json.JSONDecodeError:
        pass
    return None

data['filename'] = data['rating'].apply(extract_filename)
data = data[data['filename'].notna()]
mask = data['filename'].str.contains('/stimuli/\d+\.mp4', regex=True)
filtered_data = data[mask]
counts = filtered_data['filename'].value_counts()
results = {f'/stimuli/{i}.mp4': counts.get(f'/stimuli/{i}.mp4', 0) for i in range(1, 21)}

average_count = sum(results.values()) / 20

for video, count in results.items():
    print(f'{video}: {count}')

print(f'Average count of video appearances: {average_count}')
