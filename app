from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="ksk123",
    database="ksk_events"
)
cur = db.cursor()

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        user = request.form["username"]
        pwd = request.form["password"]

        cur.execute(
            "SELECT * FROM admin WHERE username=%s AND password=%s",
            (user, pwd)
        )
        if cur.fetchone():
            return redirect("/dashboard")
        else:
            return "Invalid Login"

    return render_template("login.html")

@app.route("/dashboard", methods=["GET", "POST"])
def dashboard():
    if request.method == "POST":
        name = request.form["name"]
        date = request.form["date"]
        venue = request.form["venue"]
        desc = request.form["description"]

        cur.execute(
            "INSERT INTO events (event_name, event_date, venue, description) VALUES (%s,%s,%s,%s)",
            (name, date, venue, desc)
        )
        db.commit()

    cur.execute("SELECT * FROM events")
    events = cur.fetchall()

    return render_template("dashboard.html", events=events)

if __name__ == "__main__":
    app.run(debug=True)
