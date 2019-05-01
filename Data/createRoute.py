import json
import requests

def strip_to_coords(j_file: str):
    j_load = json.loads(j_file)
    return j_load['features'][0]['geometry']['coordinates']

def get_coords_to_from(start: list, end: list, api_key: str = '5b3ce3597851110001cf6248e2f33c3e7ac94eb0995f9fc7ef69b4f2'):
    headers = {
    'Accept': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
    }
    url = 'https://api.openrouteservice.org/v2/directions/driving-car?api_key='+ api_key + '&start=' + str(start[1]) + ',' + str(start[0]) +'&end=' + str(end[1]) + ',' + str(end[0])
    print(url)
    call = requests.get(url, headers=headers)
    print(call.status_code, call.reason)
    
    if call.status_code ==  200:
        save_file = open("req_file.json", "w")
        save_file.write(call.text)
        save_file.close()
        return True, strip_to_coords(call.text)
    else:
        return False, [start, end]

def read_wanted(file_name: str):
    in_file = open(file_name, "r")
    in_data = json.loads(in_file.read())
    in_file.close()

    out_data = []
    for i in range(len(in_data)-1):
        start_name = in_data[i]['name']
        start_coord = [in_data[i]['lat'], in_data[i]['long']]

        stop_name = in_data[i + 1]['name']
        stop_coord = [in_data[i + 1]['lat'], in_data[i + 1]['long']]
        path = get_coords_to_from(start_coord, stop_coord)

        out_dict = {}
        out_dict["from"] = start_name
        out_dict["to"] = stop_name
        out_dict["coords"] = path

        out_data.append(out_dict)
        
    out_file = open("test_output.json", "w")
    out_file.write(json.dumps(out_data))
    out_file.close()

import os
os.chdir(os.path.dirname(__file__))
print(os.getcwd())

file_name = input("Enter file name: ")

read_wanted(file_name)
