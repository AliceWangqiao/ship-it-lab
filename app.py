from flask import Flask, jsonify
import random, os

app = Flask(__name__)
SECRET = random.randint(1, 100)

@app.route('/')
def root():
    return jsonify(msg='Guess a number 1-100, try /guess/42')

@app.route('/guess/<int:n>')
def guess(n):
    return jsonify(msg='Higher' if n < SECRET else 'Lower' if n > SECRET else 'Correct!')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
