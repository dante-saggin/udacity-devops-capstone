from flask import Flask, jsonify, render_template
from flask.logging import create_logger
import logging

app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

@app.route("/", methods=['GET'])
@app.route("/ping", methods=['GET'])
def ping():
    return jsonify(
            status="ok",
            version="v###Version###"
        )

@app.route("/mini-game/<name>", methods=['GET'])
def minigame(name):
    LOG.info(f"Get Minigame")
    return render_template("mini-game.html", name=name)

if __name__ == "__main__":
    # load pretrained model as clf
    app.run(host='0.0.0.0', port=8080, debug=True)
