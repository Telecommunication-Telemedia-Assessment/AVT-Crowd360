"""
Contains functionality to convert the head rotation data recorded by AVRate in CSV format to the same JSON format used in Headify.

@author: Stephan Fremerey
"""

import pandas as pd
import json
import sys

# df1 = pd.read_csv("_ratings.csv", dtype=str)
# df2 = pd.read_csv("_ratings2.csv", dtype=str)
# df2['user_ID'] = df2['user_ID'].astype(str) + '_colleagues'


# df = pd.concat([df1, df2])
df = pd.read_csv("_ratings.csv", dtype=str)


data_json = {
    "merged_data": []
}
number_full_subjects = 0
min_timestamp = 29000
max_timestamp = 32000
video_duration_in_s = 30

# for subject_id in range(0, 10000):
#     subject_df = df.loc[(df['user_ID'] == str(subject_id)) & (df["rating_type"] == "tracking_data")]
#     if subject_df.shape[0] == 20:
#         number_full_subjects += 1
#         data_json2 = {
#             "data": []
#         }
#         for index, row in subject_df.iterrows():
#             rating = row["rating"]
#             rating_json = json.loads(row["rating"].replace("/stimuli/", ""))
#             start_timestamp = rating_json["pitch_yaw_roll_data_hmd"][0]["sample_timestamp"]
#             end_timestamp = rating_json["pitch_yaw_roll_data_hmd"][-1]["sample_timestamp"]
#             rating_json["hmd"] = "crowd"
#             rating_json["video_length_in_s"] = 30
#             if min_timestamp <= end_timestamp - start_timestamp <= max_timestamp:
#                 data_json2["data"].append(rating_json)
#         data_json["merged_data"].append(data_json2)

for subject_id in range(0, 10000):
    subject_df = df.loc[(df['user_ID'] == str(subject_id)) & (df["rating_type"] == "tracking_data")]
    number_full_subjects += 1
    data_json2 = {
        "data": []
    }
    for index, row in subject_df.iterrows():
        rating = row["rating"]
        rating_json = json.loads(row["rating"].replace("/stimuli/", ""))
        start_timestamp = rating_json["pitch_yaw_roll_data_hmd"][0]["sample_timestamp"]
        end_timestamp = rating_json["pitch_yaw_roll_data_hmd"][-1]["sample_timestamp"]
        rating_json["hmd"] = "crowd"
        rating_json["video_length_in_s"] = 30
        # if min_timestamp <= end_timestamp - start_timestamp <= max_timestamp:
        if video_duration_in_s - 2 <= video_duration_in_s <= video_duration_in_s + 2:
            data_json2["data"].append(rating_json)
    empty_data_json2 = {
        "data": []
    }
    if data_json2 != empty_data_json2:
        data_json["merged_data"].append(data_json2)


# for subject_id in range(0, 10000):
#     subject_id = "{}_colleagues".format(subject_id)
#     subject_df = df.loc[(df['user_ID'] == str(subject_id)) & (df["rating_type"] == "tracking_data")]
#     if subject_df.shape[0] == 20:
#         number_full_subjects += 1
#         data_json2 = {
#             "data": []
#         }
#         for index, row in subject_df.iterrows():
#             rating = row["rating"]
#             rating_json = json.loads(row["rating"].replace("/stimuli/", ""))
#             start_timestamp = rating_json["pitch_yaw_roll_data_hmd"][0]["sample_timestamp"]
#             end_timestamp = rating_json["pitch_yaw_roll_data_hmd"][-1]["sample_timestamp"]
#             rating_json["hmd"] = "crowd"
#             rating_json["video_length_in_s"] = 30
#             if min_timestamp <= end_timestamp - start_timestamp <= max_timestamp:
#                 data_json2["data"].append(rating_json)
#             data_json["merged_data"].append(data_json2)

print("Number of subjects watched all contents: {}".format(number_full_subjects))

with open('ratings_json_export.json', mode='w') as new_file:
    json.dump(data_json, new_file, indent=4, sort_keys=True, separators=(',', ':'))
