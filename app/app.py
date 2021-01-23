import sys
import psycopg2
from flask import Flask

db_host = open('db_host.txt').read().strip()
my_ip = open('my_ip.txt').read().strip()

conn = psycopg2.connect(dbname='docker', user='docker',
                        password='docker', host=db_host, port=5432)
cursor = conn.cursor()

app = Flask(__name__)


@app.route('/healthcheck')
def healthcheck():
    try:
        cursor.execute("SELECT * FROM statuses WHERE status='AVAILABLE'")
        available_machines = cursor.fetchall()
        response = {
            "ip": my_ip,
            "services": [{"ip": ip, "status": status} for ip, status in available_machines]
        }
    except:
        response = {"error": "Database is unavailable"}
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
    app.run(port=80, host='0.0.0.0')