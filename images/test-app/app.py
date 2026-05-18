# ================================================
# Test Application for Container Security Scanning
# ================================================
from flask import Flask, jsonify
import os
import platform

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "app": "Container Security Framework",
        "version": "1.0.0",
        "status": "running"
    })

@app.route('/info')
def info():
    return jsonify({
        "python": platform.python_version(),
        "system": platform.system(),
        "secure": True
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)