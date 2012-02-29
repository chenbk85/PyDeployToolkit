#!/usr/bin/python
# -*- coding: utf-8 -*-
from flask import Flask, send_from_directory
app = Flask(__name__)
@app.route('/')
def hello():
    return 'Hello world from my new Flask python app!'
@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')
def application(environ, start_response):
    return app(environ, start_response)
if __name__ == '__main__':
    app.run()