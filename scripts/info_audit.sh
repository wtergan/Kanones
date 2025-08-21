#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Kanónes Info Audit ==="
command -v rg >/dev/null 2>&1 || { echo "ripgrep (rg) is required"; exit 1; }

echo "\n-- Rules (kanónes/cursor/rules/kanónes) --"
RULES_DIR="$ROOT_DIR/cursor/rules/kanónes"

# 1) Normative lines in rules
NORM_RULES=$(rg -ni '\b(must|should|never|always|required)\b' "$RULES_DIR" | wc -l | tr -d ' ')
echo "Normative lines (rules): $NORM_RULES"

# 2) Unique YAML-like field keys seen in rules (frontmatter/templates)
YAML_FIELDS=$(rg -no '^[ ]{0,3}([a-zA-Z_][a-zA-Z0-9_]*):' "$RULES_DIR" | cut -d: -f2 | sort -u | wc -l | tr -d ' ')
echo "Unique YAML-like fields (rules): $YAML_FIELDS"

# 3) Mermaid edges in rules (proxy for workflow complexity retained)
MERMAID_EDGES=$(rg -n '(->|-->)' "$RULES_DIR" | wc -l | tr -d ' ')
echo "Mermaid edges (rules): $MERMAID_EDGES"

echo "\n-- Vault (kanónes/vault) --"
VAULT_DIR="$ROOT_DIR/vault"

# 4) Normative lines in vault memory
if [ -d "$VAULT_DIR/memory" ]; then
  NORM_VAULT=$(rg -ni '\b(must|should|never|always|required)\b' "$VAULT_DIR/memory" | wc -l | tr -d ' ')
  echo "Normative lines (vault memory): $NORM_VAULT"

  # 5) ADR-lite entries in patterns (count headings with date)
  ADR_COUNT=$(rg -n '^### .+ \([0-9]{4}-[0-9]{2}-[0-9]{2}\)' "$VAULT_DIR/memory/patterns.md" 2>/dev/null | wc -l | tr -d ' ')
  echo "ADR-lite entries (patterns.md): $ADR_COUNT"

  # 6) Risks rows in active-context (count table rows)
  RISK_ROWS=$(rg -n '^\|' "$VAULT_DIR/memory/active-context.md" 2>/dev/null | wc -l | tr -d ' ')
  echo "Risk rows (active-context.md): $RISK_ROWS"

  # 7) Progress cadence (entries + Weekly Summary)
  PROG_ENTRIES=$(rg -n '^## ' "$VAULT_DIR/memory/progress.md" 2>/dev/null | wc -l | tr -d ' ')
  WEEKLY_SUM=$(rg -n '^## Weekly Summary' "$VAULT_DIR/memory/progress.md" 2>/dev/null | wc -l | tr -d ' ')
  echo "Progress entries: $PROG_ENTRIES (weekly summaries: $WEEKLY_SUM)"
else
  echo "Vault memory directory not found at: $VAULT_DIR/memory"
fi

echo "\nTip: Capture these counts pre/post-trim to verify ≥95% info retention."
