sudo apt update
sudo apt install docker.io git -y
git clone https://github.com/JandJane/cloud_hw_2.git
cd cloud_hw_2/app
sudo docker build -t app .
sudo docker run -d -p 80:80 app