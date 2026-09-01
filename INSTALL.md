# Setup completo de Claude Code — todo lo instalado

Tres partes: **plugins (marketplaces)**, **skills sueltas** y **MCP servers**.
Lo más rápido: `bash install.sh` (hace las 3 partes menos las API keys).

---

## 1. Marketplaces de plugins

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add anthropics/skills
claude plugin marketplace add addyosmani/agent-skills
claude plugin marketplace add Hainrixz/the-architect
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add ruvnet/ruflo
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
claude plugin marketplace add thedotmack/claude-mem
```

| Marketplace | Link |
|---|---|
| claude-plugins-official | https://github.com/anthropics/claude-plugins-official |
| anthropic-agent-skills | https://github.com/anthropics/skills |
| addy-agent-skills | https://github.com/addyosmani/agent-skills |
| the-architect | https://github.com/Hainrixz/the-architect |
| ponytail | https://github.com/DietrichGebert/ponytail |
| ruflo | https://github.com/ruvnet/ruflo |
| ui-ux-pro-max | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill |
| claude-mem | https://github.com/thedotmack/claude-mem |

## 2. Plugins instalados (26)

```bash
# Oficiales de Anthropic
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install claude-md-management@claude-plugins-official
claude plugin install hookify@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official
claude plugin install session-report@claude-plugins-official
claude plugin install claude-code-setup@claude-plugins-official
claude plugin install skill-creator@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install superpowers@claude-plugins-official

# Language servers (LSP)
claude plugin install typescript-lsp@claude-plugins-official
claude plugin install pyright-lsp@claude-plugins-official
claude plugin install gopls-lsp@claude-plugins-official
claude plugin install jdtls-lsp@claude-plugins-official
claude plugin install swift-lsp@claude-plugins-official
claude plugin install clangd-lsp@claude-plugins-official
claude plugin install ruby-lsp@claude-plugins-official

# Skills oficiales de Anthropic (docx/pdf/pptx/xlsx, etc.)
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills

# Comunidad
claude plugin install agent-skills@addy-agent-skills
claude plugin install the-architect@soyenriquerocha
claude plugin install ponytail@ponytail
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
claude plugin install ruflo-core@ruflo
claude plugin install claude-mem@thedotmack
```

> **Ojo con ruflo:** instalar SOLO `ruflo-core`. Los sub-plugins `ruflo-neural-trader` y
> `ruflo-market-data` traen un skill que ejecuta operaciones financieras reales. No instalar.

## 3. Skills sueltas (~/.claude/skills/)

**170 skills** están en la carpeta `skills/` de este repo. Copiar tal cual:

```bash
mkdir -p ~/.claude/skills && cp -Rn skills/* ~/.claude/skills/
```

> `-n` = no sobrescribe skills que ya tengas.

Incluye: game-dev completo (GDD, sprints, QA, release), diseño/animación
(apple-design, animate, emil-design-eng, liquid-glass-design, shadcn-ui),
backend/testing por lenguaje (Django, Spring Boot, Go, C++, Python, Swift),
seguridad (security-review, security-audit, strix), research (deep-research,
agent-reach, web-reader), graphify, ECC, y más.

### Skills que son repos git aparte (clonar, no copiar)

```bash
cd ~/.claude/skills
git clone https://github.com/garrytan/gstack.git
git clone https://github.com/Hainrixz/humanizalo.git
git clone https://github.com/Hainrixz/claude-webkit.git
git clone https://github.com/Hainrixz/claude-banana.git
git clone https://github.com/Hainrixz/skill-vault.git
git clone https://github.com/Hainrixz/whatsapp-agentkit.git
```

| Skill | Link |
|---|---|
| gstack (suite completa: /ship, /review, /qa, /browse…) | https://github.com/garrytan/gstack |
| humanizalo | https://github.com/Hainrixz/humanizalo |
| claude-webkit | https://github.com/Hainrixz/claude-webkit |
| claude-banana | https://github.com/Hainrixz/claude-banana |
| skill-vault | https://github.com/Hainrixz/skill-vault |
| whatsapp-agentkit | https://github.com/Hainrixz/whatsapp-agentkit |

## 4. MCP servers

```bash
claude mcp add -s user chrome-devtools -- npx chrome-devtools-mcp@1.7.0
claude mcp add -s user playwright -- npx @playwright/mcp@latest
claude mcp add -s user --transport http context7 https://mcp.context7.com/mcp
# Firecrawl necesita TU PROPIA API key (https://firecrawl.dev)
claude mcp add -s user firecrawl --env FIRECRAWL_API_KEY=TU_API_KEY -- npx -y firecrawl-mcp
```

> `-s user` es obligatorio: sin eso los MCP quedan atados a la carpeta donde corriste
> el comando y no aparecen en tus otros proyectos.

| MCP | Link |
|---|---|
| chrome-devtools-mcp | https://github.com/ChromeDevTools/chrome-devtools-mcp |
| playwright-mcp | https://github.com/microsoft/playwright-mcp |
| context7 | https://github.com/upstash/context7 |
| firecrawl-mcp | https://github.com/firecrawl/firecrawl-mcp-server |

## 5. Herramientas CLI

```bash
brew install jq gh          # jq lo necesitan varios hooks; gh para GitHub
```

```bash
# graphify (grafo de conocimiento del código, usado por el skill /graphify)
uv tool install graphifyy      # deja graphify y graphify-mcp en ~/.local/bin
```

Si no tenés `uv`: `brew install uv`.
Opcional: `brew install ollama` (algunos skills lo usan para modelos locales).

## 6. Configuración global (opcional)

- `CLAUDE.md.example` → copiar a `~/.claude/CLAUDE.md` (reglas globales).
- `settings.reference.json` → referencia de `~/.claude/settings.json`
  (hooks de graphify + plugins habilitados). **No trae ninguna API key.**
- `statusline-command.sh` → barra de estado (modelo | carpeta | branch | contexto | costo):

```bash
cp statusline-command.sh ~/.claude/
```

y en `~/.claude/settings.json`:

```json
"statusLine": { "type": "command", "command": "bash ~/.claude/statusline-command.sh" }
```
