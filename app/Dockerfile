FROM python:3.8-slim-buster
COPY . /app
COPY ../../my_ip.txt /app
COPY ../../db_host.txt /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 80
CMD python app.py my_machine