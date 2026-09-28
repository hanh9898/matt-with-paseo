#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
git init -q -b main .
mkdir -p src
cat > src/app.py <<'EOF'
print("hello")
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q --allow-empty -m fixture
