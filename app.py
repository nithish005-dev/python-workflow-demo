from flask import Flask, jsonify
import os
from datetime import datetime

app = Flask(__name__)

# Health check endpoint
@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint that returns the status of the application."""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat(),
        'service': 'python-workflow-demo'
    }), 200

# Welcome endpoint
@app.route('/', methods=['GET'])
def welcome():
    """Welcome endpoint."""
    return jsonify({
        'message': 'Welcome to Python Workflow Demo',
        'version': '1.0.0'
    }), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
