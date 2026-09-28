#!/usr/bin/env bash
set -euo pipefail
git init -q -b main .
mkdir -p src
cat > src/app.py <<'EOF'
print("hello")
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q --allow-empty -m fixture
