#!/bin/bash
# Claude Code statusline
# Shows: model | short cwd | git branch | context usage | cost so far
# Fast, local-only (no network calls), robust to missing fields.

input=$(cat)

has_jq=0
command -v jq >/dev/null 2>&1 && has_jq=1

get() {
  # $1 = jq filter (with // empty fallback baked in by caller)
  if [ "$has_jq" = "1" ]; then
    printf '%s' "$input" | jq -r "$1 // empty" 2>/dev/null
  fi
}

# --- model ---
model=$(get '.model.display_name')
[ -z "$model" ] && model=$(get '.model.id')

# --- cwd (short form: last folder, ~ for home) ---
cwd=$(get '.workspace.current_dir')
[ -z "$cwd" ] && cwd=$(get '.cwd')

short_cwd=""
if [ -n "$cwd" ]; then
  short_cwd="${cwd/#$HOME/~}"
  base=$(basename "$cwd" 2>/dev/null)
  if [ "$short_cwd" = "~" ]; then
    short_cwd="~"
  elif [ -n "$base" ]; then
    short_cwd="~/$base"
    [ "${cwd#$HOME}" = "$cwd" ] && short_cwd="$base"
  fi
fi

# --- git branch (local read only, skip optional locks, no network) ---
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi

# --- context / token usage ---
ctx=""
used_pct=$(get '.context_window.used_percentage')
if [ -n "$used_pct" ]; then
  ctx=$(printf 'ctx %.0f%%' "$used_pct")
else
  total_in=$(get '.context_window.total_input_tokens')
  win=$(get '.context_window.context_window_size')
  if [ -n "$total_in" ] && [ -n "$win" ] && [ "$win" != "0" ]; then
    pct=$(awk -v a="$total_in" -v b="$win" 'BEGIN{printf "%.0f", (a/b)*100}' 2>/dev/null)
    [ -n "$pct" ] && ctx="ctx ${pct}%"
  elif [ -n "$total_in" ]; then
    ctx="${total_in} tok"
  fi
fi

# --- cost so far (only if the field is present in the payload) ---
cost=""
cost_raw=$(get '.cost.total_cost_usd')
[ -z "$cost_raw" ] && cost_raw=$(get '.total_cost_usd')
[ -z "$cost_raw" ] && cost_raw=$(get '.cost_usd')
if [ -n "$cost_raw" ]; then
  cost=$(awk -v c="$cost_raw" 'BEGIN{printf "$%.2f", c}' 2>/dev/null)
fi

# --- assemble single-line output, skipping any missing pieces ---
out="$model"
[ -n "$short_cwd" ] && out="${out:+$out }$short_cwd"
[ -n "$branch" ] && out="$out ($branch)"
[ -n "$ctx" ] && out="${out:+$out | }$ctx"
[ -n "$cost" ] && out="${out:+$out | }$cost"

[ -z "$out" ] && out="claude"

printf '%s' "$out"
