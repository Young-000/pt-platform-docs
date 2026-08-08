#!/usr/bin/env bash
# scripts/verify.sh — pt-platform-docs markdown integrity verifier
# Jekyll 순수 문서 사이트 (package.json 없음)
# Usage: bash scripts/verify.sh
# Exit: 0 = GREEN, 1 = RED

FAIL=0
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "=== verify.sh: pt-platform-docs ==="
echo "Root: $ROOT"

# ── 1. Frontmatter integrity ──────────────────────────────────
echo ""
echo "[1/3] Frontmatter check (title field, unclosed YAML)..."
python3 - <<'PYEOF'
import os, sys
errors = []
for root, dirs, files in os.walk('.'):
    dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['vendor', '_site', 'docs', 'scripts']]
    for f in sorted(files):
        if not f.endswith('.md'):
            continue
        path = os.path.join(root, f)
        with open(path, 'r', encoding='utf-8') as fp:
            content = fp.read()
        if not content.startswith('---'):
            # Some files (README, top-level) may not have frontmatter — skip
            continue
        end = content.find('---', 3)
        if end == -1:
            errors.append(f'UNCLOSED frontmatter: {path}')
            continue
        fm = content[3:end]
        if 'title:' not in fm:
            errors.append(f'Missing title: {path}')
if errors:
    for e in errors:
        print(f'  ERR  {e}')
    sys.exit(1)
print(f'  PASS')
PYEOF
[ $? -eq 0 ] || FAIL=1

# ── 2. Internal link integrity ────────────────────────────────
echo ""
echo "[2/3] Internal link check (relative .html/.md links)..."
python3 - <<'PYEOF'
import os, sys, re
errors = []
for root, dirs, files in os.walk('.'):
    dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['vendor', '_site', 'scripts']]
    for f in sorted(files):
        if not f.endswith('.md'):
            continue
        path = os.path.join(root, f)
        with open(path, 'r', encoding='utf-8') as fp:
            content = fp.read()
        links = re.findall(r'\]\(([^)]+)\)', content)
        for link in links:
            target = link.split('#')[0].strip()
            if not target:
                continue
            if target.startswith('http') or target.startswith('mailto') or target.startswith('/'):
                continue
            # Jekyll generates .html from .md — convert back for existence check
            if target.endswith('.html'):
                target_md = target[:-5] + '.md'
            else:
                target_md = target
            candidate = os.path.normpath(os.path.join(root, target_md))
            if not os.path.exists(candidate):
                # Also try without extension (dir index)
                if not os.path.isdir(os.path.normpath(os.path.join(root, target.rstrip('/')))):
                    errors.append(f'{path}: broken -> {link}')
if errors:
    for e in errors[:30]:
        print(f'  ERR  {e}')
    sys.exit(1)
print(f'  PASS')
PYEOF
[ $? -eq 0 ] || FAIL=1

# ── 3. Jekyll build (optional — skips gracefully if not installed) ─
echo ""
echo "[3/3] Jekyll build check..."
if command -v bundle &>/dev/null && bundle exec jekyll version &>/dev/null 2>&1; then
  if bundle exec jekyll build --quiet 2>&1; then
    echo "  PASS"
  else
    echo "  FAIL (jekyll build error)"
    FAIL=1
  fi
else
  echo "  SKIP (Jekyll gems not installed locally — CI/GitHub Pages builds remotely)"
fi

# ── Result ────────────────────────────────────────────────────
echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "VERIFY: GREEN"
  exit 0
else
  echo "VERIFY: RED"
  exit 1
fi
