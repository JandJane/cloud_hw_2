import sys
import psycopg2
from flask import Flask

if len(sys.argv) > 1:
    name = sys.argv[1]
else:
    name = 'machine_name'

conn = psycopg2.connect(dbname='docker', user='docker',
                        password='docker', host='localhost', port=54321)
cursor = conn.cursor()

app = Flask(name)


@app.route('/healthcheck')
def healthcheck():
    cursor.execute("SELECT * FROM statuses WHERE status='AVAILABLE'")
    available_machines = cursor.fetchall()
    response = {
        "ip": name,
        "services": [{"ip": ip, "status": status} for ip, status in available_machines]
    }
    return response


if __name__ == '__main__':
    cursor.execute(f"SELECT * FROM statuses WHERE ip='{name}'")
    records = cursor.fetchall()
    if records:
        cursor.execute(f"UPDATE statuses SET status='AVAILABLE' WHERE ip='{name}'")
        conn.commit()
    else:
        cursor.execute(f"INSERT INTO statuses VALUES ('{name}', 'AVAILABLE')")
        conn.commit()
    app.run(port=80)