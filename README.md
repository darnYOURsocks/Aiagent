# TPSAI Agent (PDF ⇄ DB ⇄ Answer)

A minimal agent that ingests **ASCII-symbolised PDFs** (with `TP:` control lines), parses and stores
them in SQLite, builds a TF‑IDF index with a TPS boost, and answers natural‑language queries with provenance.

## Quickstart

```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Open: http://127.0.0.1:8000/docs

### Endpoints
- `POST /ingest/pdf` – upload a symbolised PDF (form file). Builds index automatically.
- `GET /outline` – view current outline (sections/subsections).
- `GET /procedure` – view current procedure view.
- `POST /query` – ask a question; returns answer + provenance.

### Data locations
- SQLite DB: `data/tpsai.db`
- Index: `data/index/` (tfidf.npz, vectorizer.pkl, tps_boost.json, meta.json)

### Symbol contract (ASCII-only)
Control lines are **one per line**, e.g.:
```
TP:DOC|id=doc_x|title=...|version=...|author=...
TP:PAGE|n=1
TP:SEC|id=s1|level=1|title=Section_Title
TP:STEP|id=st1|n=1
TP:BUL|id=b1
TP:TIP|id=t1
TP:RFC|id=r1|code=E0.42_L0.35_H0.23|tps=0.331
TP:LINK|from=st1|rel=requires|to=st2
TP:ENDDOC
```

### Sample
- `sample/system_test.txt` – the system test block.
- `sample/make_pdf.py` – creates a PDF.
- `sample/ingest_demo.sh` – curl upload and query.

## Notes
- This is SQLite + TF‑IDF for simplicity. Swap to Postgres/pgvector or Milvus as needed.
- The agent expands top hits to their owning Section/Subsection and composes a procedure-style answer.
