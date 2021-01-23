IP_BACKEND1=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][1]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")
IP_BACKEND2=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][2]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")
IP_DB=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][3]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")
IP_NGINX=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][4]['instances'][0]['attributes']['network_interface'][0]['nat_ip_address'])")

# Database
ssh ubuntu@$IP_DB 'bash -s' < deploy_db.sh

# Backends
INTERNAL_IP_DB=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][3]['instances'][0]['attributes']['network_interface'][0]['ip_address'])")

ssh ubuntu@$IP_BACKEND1 'echo '$IP_BACKEND1' > my_ip.txt'
ssh ubuntu@$IP_BACKEND1 'echo '$INTERNAL_IP_DB' > db_host.txt'
ssh ubuntu@$IP_BACKEND1 'bash -s' < deploy_backend.sh

ssh ubuntu@$IP_BACKEND2 'echo '$IP_BACKEND2' > my_ip.txt'
ssh ubuntu@$IP_BACKEND2 'echo '$INTERNAL_IP_DB' > db_host.txt'
ssh ubuntu@$IP_BACKEND2 'bash -s' < deploy_backend.sh

# Nginx
INTERNAL_IP_BACKEND1=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][1]['instances'][0]['attributes']['network_interface'][0]['ip_address'])")
INTERNAL_IP_BACKEND2=$(python -c "import json; print(json.load(open('terraform.tfstate'))['resources'][2]['instances'][0]['attributes']['network_interface'][0]['ip_address'])")

ssh ubuntu@$IP_NGINX 'sudo apt update && sudo apt install -y nginx'
ssh ubuntu@$IP_NGINX 'sudo service nginx start'
ssh ubuntu@$IP_NGINX 'sudo chmod 777 /etc/nginx/nginx.conf'

ssh ubuntu@$IP_NGINX 'bash -s' < deploy_nginx.sh
 ssh ubuntu@$IP_NGINX 'echo "
  pid /run/nginx.pid;

  events {
        worker_connections 768;
  }

  http {
          upstream myapp1 {
              server '$INTERNAL_IP_BACKEND1';
              server '$INTERNAL_IP_BACKEND2';
          }

          server {
              listen 80;

              location / {
                  proxy_pass http://myapp1;
              }
          }
  }" > /etc/nginx/nginx.conf'

ssh ubuntu@$IP_NGINX 'sudo systemctl restart nginx'

# Remove NAT
yc compute instance remove-one-to-one-nat db --network-interface-index 0
yc compute instance remove-one-to-one-nat backend1 --network-interface-index 0
yc compute instance remove-one-to-one-nat backend2 --network-interface-index 0