#!/usr/bin/env bash
set -euo pipefail
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000 &
PID=$!
sleep 3
python sample/make_pdf.py sample/system_test.txt sample/system_test.pdf
curl -s -F "file=@sample/system_test.pdf" http://127.0.0.1:8000/ingest/pdf >/dev/null
curl -s -X POST http://127.0.0.1:8000/query -H "Content-Type: application/json" -d '{"query":"total price for six windows with triple glaze and deposit"}' | jq
kill $PID || true
