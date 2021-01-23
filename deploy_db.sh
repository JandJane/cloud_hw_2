sudo apt update
sudo apt install docker.io git -y
git clone https://github.com/JandJane/cloud_hw_2.git
cd cloud_hw_2/database
sudo docker build -t my_postgresql .
sudo docker run -d -p 5432:5432 -v pg_data1:/etc/postgresql -v pg_data2:/var/log/postgresql -v pg_data3:/var/lib/postgresql my_postgresql