#!/usr/bin/env bash
# Instala todo el setup de Claude Code. Uso: bash install.sh
set -u
say(){ printf "\n\033[1m==> %s\033[0m\n" "$*"; }

say "Marketplaces"
for m in anthropics/claude-plugins-official anthropics/skills addyosmani/agent-skills \
         Hainrixz/the-architect DietrichGebert/ponytail ruvnet/ruflo \
         nextlevelbuilder/ui-ux-pro-max-skill thedotmack/claude-mem; do
  claude plugin marketplace add "$m" || echo "  (ya estaba o falló: $m)"
done

say "Plugins"
for p in pr-review-toolkit commit-commands claude-md-management hookify security-guidance \
         session-report claude-code-setup skill-creator feature-dev frontend-design superpowers \
         typescript-lsp pyright-lsp gopls-lsp jdtls-lsp swift-lsp clangd-lsp ruby-lsp; do
  claude plugin install "$p@claude-plugins-official" || echo "  (falló: $p)"
done
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills
claude plugin install agent-skills@addy-agent-skills
claude plugin install the-architect@soyenriquerocha
claude plugin install ponytail@ponytail
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
claude plugin install ruflo-core@ruflo   # SOLO core: no instalar los sub-plugins de trading
claude plugin install claude-mem@thedotmack

say "Skills (170)"
mkdir -p ~/.claude/skills
cp -Rn "$(dirname "$0")"/skills/* ~/.claude/skills/

say "Skills que son repos git"
cd ~/.claude/skills
for r in garrytan/gstack Hainrixz/humanizalo Hainrixz/claude-webkit \
         Hainrixz/claude-banana Hainrixz/skill-vault Hainrixz/whatsapp-agentkit; do
  [ -d "$(basename "$r")" ] || git clone "https://github.com/$r.git"
done
cd - >/dev/null

say "MCP servers"
claude mcp add -s user chrome-devtools -- npx chrome-devtools-mcp@1.7.0
claude mcp add -s user playwright -- npx @playwright/mcp@latest
claude mcp add -s user --transport http context7 https://mcp.context7.com/mcp
echo "  firecrawl: agregalo con TU key ->"
echo "  claude mcp add -s user firecrawl --env FIRECRAWL_API_KEY=TU_KEY -- npx -y firecrawl-mcp"

say "graphify + statusline"
command -v uv >/dev/null 2>&1 && uv tool install graphifyy || echo "  (instalá uv: brew install uv, luego: uv tool install graphifyy)"
cp "$(dirname "$0")/statusline-command.sh" ~/.claude/ 2>/dev/null

say "Listo. Reiniciá Claude Code. Falta: brew install jq gh"
