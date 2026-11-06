#!/usr/bin/env python3
"""Run the three representative DOM fixtures in isolated headless Firefox.

No dependencies beyond Python's standard library and Firefox. This is not an
Obsidian integration test. Run from any directory; it never opens the real vault.
"""

import json
import os
from pathlib import Path
import signal
import subprocess
import tempfile
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from threading import Event, Thread
from urllib.parse import unquote, urlparse


def main():
    root = Path(__file__).absolute().parents[3]
    fixtures = [
        "/docs/obsidian/themes/hendriks-theme/tests/editor-spacing.html",
        "/docs/obsidian/themes/hendriks-theme/tests/headings.html",
        "/docs/obsidian/tests/calendar.html",
    ]
    assets = [
        "/obsidian/.obsidian/themes/Hendrik's Theme/theme.css",
        "/obsidian/.obsidian/plugins/hendrik-keyboard/main.js",
        "/obsidian/.obsidian/plugins/hendrik-keyboard/styles.css",
    ]
    results = []
    finished = Event()

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *_args):
            pass

        def do_GET(self):
            path = unquote(urlparse(self.path).path)
            if path not in fixtures + assets:
                self.send_error(404)
                return
            content = (root / path.lstrip("/")).read_text()
            if path in fixtures:
                index = fixtures.index(path)
                next_page = fixtures[index + 1] if index + 1 < len(fixtures) else None
                script = """<script>window.addEventListener('load', async () => {
                  try {
                    const result = await (window.fixturePromise ||
                      (window.runHeadingTests ? runHeadingTests() : runSpacingTests()));
                    await fetch('/result', {method:'POST', body:JSON.stringify({fixture:location.pathname,...result})});
                    const nextPage = NEXT_PAGE;
                    if (nextPage) location.href = nextPage;
                  } catch(error) {
                    await fetch('/result', {method:'POST', body:JSON.stringify({passed:false,error:String(error)})});
                  }
                });</script>""".replace("NEXT_PAGE", json.dumps(next_page))
                content = content.replace("</body>", script + "</body>")
            mime = {".html": "text/html", ".css": "text/css", ".js": "text/javascript"}
            self.send_response(200)
            self.send_header("Content-Type", mime[Path(path).suffix])
            self.end_headers()
            self.wfile.write(content.encode())

        def do_POST(self):
            length = int(self.headers.get("Content-Length", "0"))
            if self.path != "/result" or not 0 < length < 1_000_000:
                self.send_error(400)
                return
            result = json.loads(self.rfile.read(length))
            results.append(result)
            self.send_response(200)
            self.end_headers()
            if len(results) == len(fixtures) or result.get("error"):
                finished.set()

    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    Thread(target=server.serve_forever, daemon=True).start()
    scratch = "/tmp/opencode" if Path("/tmp/opencode").is_dir() else None
    try:
        with tempfile.TemporaryDirectory(prefix="obsidian-tests-", dir=scratch) as profile:
            with tempfile.TemporaryFile(mode="w+") as log:
                browser = subprocess.Popen(
                    ["firefox", "--headless", "--no-remote", "--profile", profile,
                     f"http://127.0.0.1:{server.server_port}{fixtures[0]}"],
                    stdout=log, stderr=log, start_new_session=True,
                )
                try:
                    completed = finished.wait(45)
                finally:
                    if browser.poll() is None:
                        os.killpg(browser.pid, signal.SIGTERM)
                    try:
                        browser.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        os.killpg(browser.pid, signal.SIGKILL)
                        browser.wait()
                if not completed:
                    log.seek(0)
                    raise RuntimeError("Browser fixture timed out:\n" + log.read()[-3000:])
    finally:
        server.shutdown()
        server.server_close()
    for result in results:
        print(json.dumps({
            "fixture": result.get("fixture"), "passed": result["passed"],
            "checks": len(result.get("results", [])),
            "failures": [row for row in result.get("results", []) if not row["passed"]],
            **({"error": result["error"]} if "error" in result else {}),
        }, indent=2))
    return 0 if len(results) == len(fixtures) and all(row["passed"] for row in results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
