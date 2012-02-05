#!/usr/bin/python
# -*- coding: utf-8 -*-
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return 'Hello world from my new Flask python app!'
def application(environ, start_response):
    return app(environ, start_response)
if __name__ == '__main__':
    app.run()