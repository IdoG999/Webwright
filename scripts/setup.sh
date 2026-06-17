#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Webwright setup"
echo "    Project: $ROOT"

if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is required (3.10+)." >&2
  exit 1
fi

PYTHON_VERSION="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
echo "    Python:  $PYTHON_VERSION"

if [[ ! -d .venv ]]; then
  echo "==> Creating virtual environment"
  python3 -m venv .venv
fi

# shellcheck disable=SC1091
source .venv/bin/activate

echo "==> Installing Python dependencies"
pip install --upgrade pip
pip install -r requirements.txt

echo "==> Installing Playwright Firefox browser"
playwright install firefox

mkdir -p outputs

if [[ ! -f .env ]] && [[ -f .env.example ]]; then
  cp .env.example .env
  echo "==> Created .env from .env.example (edit if using harness mode)"
fi

echo ""
echo "Done! Next steps:"
echo "  1. source .venv/bin/activate"
echo "  2. Open this folder in Cursor"
echo "  3. In Agent chat: @webwright <your web task>"
echo "  4. Read docs/TUTORIAL.md for the full walkthrough"
