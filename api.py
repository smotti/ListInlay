from flask import Flask, json, request, Response
from flask_cors import CORS


app = Flask(__name__)
CORS(app)


ENTRIES = [
        { "id": 1, "name": "Henry Lexington", "address": "Nordwalk St." },
        { "id": 2, "name": "Jordan Yellow", "address": "Civic Blvd" },
        { "id": 3, "name": "Jessica Northon", "address": "Sedgeway" }
        ]

ENTRY_DETAIL = {
        1: "More information about Henry",
        2: "More information about Jordan",
        3: "More information about Jessica"
        }


@app.route('/entries', methods=['GET'])
def entries():
    return Response(json.dumps(ENTRIES), content_type='application/json')


@app.route('/entries/<int:anId>', methods=['GET'])
def entry(anId=None):
    e = [e for e in ENTRIES if anId == e['id']][0]
    e.update({"details": ENTRY_DETAIL[anId]})
    return Response(json.dumps(e), content_type='application/json')


if __name__ == '__main__':
    app.run()
