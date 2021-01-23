sudo apt update
sudo apt install docker.io git postgresql postgresql-contrib -y
git clone https://github.com/JandJane/cloud_hw_2.git
cd cloud_hw_2/database
sudo docker build -t my_postgresql .
sudo docker run -d -p 54321:5432 -v pg_data1:/etc/postgresql -v pg_data2:/var/log/postgresql -v pg_data3:/var/lib/postgresql my_postgresql
export PGPASSWORD=docker
psql -h localhost -p 54321 -d docker -U docker --command "CREATE TABLE statuses (ip varchar(80), status varchar(80));"