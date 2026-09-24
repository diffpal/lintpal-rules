#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lintpal_bin="${LINTPAL_BIN:-lintpal}"
tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

init_repo() {
  local path="$1"
  mkdir -p "$path"
  git -C "$path" init -q
}

validate_import() {
  local source="$1"
  local worktree="$2"
  init_repo "$worktree"
  (
    cd "$worktree"
    "$lintpal_bin" rule import "$source"
    "$lintpal_bin" rule validate
  )
}

validate_import "$repo_root/general" "$tmp_root/general"
validate_import "$repo_root/go" "$tmp_root/go"

mkdir -p "$tmp_root/catalog-source/general" "$tmp_root/catalog-source/go"
cp "$repo_root"/general/*.md "$tmp_root/catalog-source/general/"
cp "$repo_root"/go/*.md "$tmp_root/catalog-source/go/"
validate_import "$tmp_root/catalog-source" "$tmp_root/catalog"

mkdir -p "$tmp_root/malformed-source"
cat >"$tmp_root/malformed-source/broken.md" <<'EOF'
---
severity: urgent
---

This fixture must be rejected.
EOF
init_repo "$tmp_root/malformed"
if (
  cd "$tmp_root/malformed"
  "$lintpal_bin" rule import "$tmp_root/malformed-source"
); then
  echo "expected malformed rule import to fail" >&2
  exit 1
fi

echo "rule catalog validation passed"
