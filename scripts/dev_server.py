#!/usr/bin/env python3
"""
وضّح — خادم تطوير محلي
يخدم docs/ كموقع ثابت ويحاكي دالة Vercel ‏/api/chat محليًا.

المفتاح يُقرأ من متغير البيئة OPENAI_API_KEY — لا تضعه في أي ملف داخل المستودع.

    export OPENAI_API_KEY=sk-...   # اختياري؛ بدونه يرجع المحاكي للرد الافتراضي
    python3 scripts/dev_server.py
"""
import json
import os
import urllib.request
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

PORT = 4173
DOCS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "docs")

SYSTEM_PROMPT = (
    "أنت \"وضّح\"، مساعد بنكي ذكي داخل تطبيق البنك في السعودية. "
    "فسّر عمليات كشف الحساب والرسوم والاشتراكات بالعربية وبإيجاز (٣ جمل كحد أقصى). "
    "هوية التجار تُوثَّق من منصة واثق. لا تختلق أرقام سجلات أو مبالغ، "
    "ولا تتعامل مع بيانات شخصية، وأعد التوجيه بلطف إن خرج السؤال عن نطاقك."
)


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DOCS, **kwargs)

    def _json(self, code, payload):
        body = json.dumps(payload, ensure_ascii=False).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path != "/api/chat":
            return self._json(404, {"error": "not-found"})

        key = os.environ.get("OPENAI_API_KEY")
        if not key:
            return self._json(503, {"error": "ai-not-configured"})

        try:
            length = int(self.headers.get("Content-Length", 0))
            message = json.loads(self.rfile.read(length)).get("message", "")
            if not message or not isinstance(message, str) or len(message) > 500:
                return self._json(400, {"error": "bad-request"})

            req = urllib.request.Request(
                "https://api.openai.com/v1/chat/completions",
                data=json.dumps({
                    "model": "gpt-4o-mini",
                    "temperature": 0.4,
                    "max_tokens": 220,
                    "messages": [
                        {"role": "system", "content": SYSTEM_PROMPT},
                        {"role": "user", "content": message},
                    ],
                }).encode(),
                headers={
                    "Content-Type": "application/json",
                    "Authorization": "Bearer " + key,
                },
            )
            with urllib.request.urlopen(req, timeout=20) as resp:
                data = json.load(resp)
            reply = data["choices"][0]["message"]["content"].strip()
            return self._json(200, {"reply": reply})
        except Exception as e:  # noqa: BLE001 — خادم تجريبي محلي
            print("chat proxy error:", e)
            return self._json(502, {"error": "upstream"})


if __name__ == "__main__":
    configured = "بمفتاح OpenAI ✓" if os.environ.get("OPENAI_API_KEY") else "بدون مفتاح (سيُستخدم الرد الافتراضي)"
    print(f"وضّح dev server → http://localhost:{PORT}  [{configured}]")
    ThreadingHTTPServer(("", PORT), Handler).serve_forever()
