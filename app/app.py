import sys
import psycopg2
from flask import Flask

db_host = open('~/db_host.txt').read()
my_ip = open('~/my_ip.txt').read()

conn = psycopg2.connect(dbname='docker', user='docker',
                        password='docker', host=db_host, port=5432)
cursor = conn.cursor()

app = Flask(my_ip)


@app.route('/healthcheck')
def healthcheck():
    cursor.execute("SELECT * FROM statuses WHERE status='AVAILABLE'")
    available_machines = cursor.fetchall()
    response = {
        "ip": my_ip,
        "services": [{"ip": ip, "status": status} for ip, status in available_machines]
    }
    return response


if __name__ == '__main__':
    cursor.execute(f"SELECT * FROM statuses WHERE ip='{my_ip}'")
    records = cursor.fetchall()
    if records:
        cursor.execute(f"UPDATE statuses SET status='AVAILABLE' WHERE ip='{my_ip}'")
        conn.commit()
    else:
        cursor.execute(f"INSERT INTO statuses VALUES ('{my_ip}', 'AVAILABLE')")
        conn.commit()
    app.run(port=80)