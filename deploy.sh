IP_BACKEND1=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][1]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")
IP_BACKEND2=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][2]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")
IP_DB=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][3]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")
IP_NGINX=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][4]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")

# Database
ssh ubuntu@$IP_DB -i ~/.ssh/id_rsa 'bash -s' < deploy_db.sh

# Backends
ssh ubuntu@$IP_BACKEND1 -i ~/.ssh/id_rsa 'echo '$IP_BACKEND1' > my_ip.txt'
ssh ubuntu@$IP_BACKEND1 -i ~/.ssh/id_rsa 'echo '$IP_DB' > db_host.txt'
ssh ubuntu@$IP_BACKEND1 -i ~/.ssh/id_rsa 'bash -s' < deploy_backend.sh

ssh ubuntu@$IP_BACKEND2 -i ~/.ssh/id_rsa 'echo '$IP_BACKEND2' > my_ip.txt'
ssh ubuntu@$IP_BACKEND2 -i ~/.ssh/id_rsa 'echo '$IP_DB' > db_host.txt'
ssh ubuntu@$IP_BACKEND2 -i ~/.ssh/id_rsa 'bash -s' < deploy_backend.sh