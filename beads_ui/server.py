#!/usr/bin/env python3
"""
Beads UI — local web server for browsing .beads/issues.jsonl as a collapsible tree.

Usage:
    python3 beads_ui/server.py [--port 7842] [--host 127.0.0.1] [--beads .beads]

Reads the raw issues.jsonl file directly and serves it as JSON. POST /api/pull
runs `bd --sandbox dolt pull` to fetch the latest from the Dolt remote (bd
auto-exports to issues.jsonl) before the next read.
"""

import argparse
import json
import os
import subprocess
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse

ROOT = os.path.dirname(os.path.abspath(__file__))
STATIC = os.path.join(ROOT, "static")


def load_issues(beads_dir: str):
    path = os.path.join(beads_dir, "issues.jsonl")
    issues = []
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                issues.append(json.loads(line))
            except json.JSONDecodeError as e:
                sys.stderr.write(f"skip bad line: {e}\n")
    mtime = os.path.getmtime(path)
    return issues, mtime


def dolt_pull(beads_dir: str):
    """Run `bd --sandbox dolt pull` in the repo (parent of .beads) to fetch the
    latest issues from the Dolt remote. bd auto-exports to issues.jsonl on pull,
    so the server's subsequent read picks up the new state. --sandbox disables
    bd's auto-push wrapper (which hangs on interactive git auth here)."""
    repo_root = os.path.dirname(os.path.abspath(beads_dir))
    try:
        proc = subprocess.run(
            ["bd", "--sandbox", "dolt", "pull"],
            cwd=repo_root,
            capture_output=True,
            text=True,
            timeout=120,
            env={**os.environ, "BD_NON_INTERACTIVE": "1"},
        )
    except FileNotFoundError:
        return {"ok": False, "error": "bd not found on PATH"}
    except subprocess.TimeoutExpired:
        return {"ok": False, "error": "bd dolt pull timed out"}
    out = (proc.stdout or "") + (proc.stderr or "")
    return {"ok": proc.returncode == 0, "output": out.strip(), "code": proc.returncode}


def make_handler(beads_dir: str):
    class Handler(BaseHTTPRequestHandler):
        def log_message(self, fmt, *args):
            sys.stderr.write("[beads_ui] " + fmt % args + "\n")

        def _send_json(self, obj, status=200):
            body = json.dumps(obj).encode("utf-8")
            self.send_response(status)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            self.wfile.write(body)

        def _send_file(self, path: str, content_type: str):
            try:
                with open(path, "rb") as f:
                    data = f.read()
            except FileNotFoundError:
                self.send_error(404, "not found")
                return
            self.send_response(200)
            self.send_header("Content-Type", content_type)
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            self.wfile.write(data)

        def do_POST(self):
            parsed = urlparse(self.path)
            if parsed.path == "/api/pull":
                result = dolt_pull(beads_dir)
                self._send_json(result, 200 if result.get("ok") else 502)
                return
            self.send_error(404, "not found")

        def do_GET(self):
            parsed = urlparse(self.path)
            path = parsed.path

            if path == "/" or path == "/index.html":
                self._send_file(os.path.join(STATIC, "index.html"), "text/html; charset=utf-8")
                return
            if path == "/static/app.js":
                self._send_file(os.path.join(STATIC, "app.js"), "application/javascript; charset=utf-8")
                return
            if path == "/static/styles.css":
                self._send_file(os.path.join(STATIC, "styles.css"), "text/css; charset=utf-8")
                return

            if path == "/api/issues":
                try:
                    issues, mtime = load_issues(beads_dir)
                except FileNotFoundError as e:
                    self._send_json({"error": str(e)}, 500)
                    return
                self._send_json({"issues": issues, "mtime": mtime, "count": len(issues)})
                return

            if path == "/api/meta":
                p = os.path.join(beads_dir, "issues.jsonl")
                try:
                    st = os.stat(p)
                    self._send_json({"mtime": st.st_mtime, "size": st.st_size, "path": p})
                except FileNotFoundError as e:
                    self._send_json({"error": str(e)}, 500)
                return

            self.send_error(404, "not found")

    return Handler


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=7842)
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--beads", default=os.path.join(os.getcwd(), ".beads"))
    args = ap.parse_args()

    if not os.path.isdir(args.beads):
        sys.exit(f"not a directory: {args.beads}")
    issues_path = os.path.join(args.beads, "issues.jsonl")
    if not os.path.isfile(issues_path):
        sys.exit(f"missing file: {issues_path}")

    handler = make_handler(args.beads)
    srv = ThreadingHTTPServer((args.host, args.port), handler)
    sys.stderr.write(f"[beads_ui] serving {issues_path}\n")
    sys.stderr.write(f"[beads_ui] http://{args.host}:{args.port}/\n")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        srv.server_close()


if __name__ == "__main__":
    main()
