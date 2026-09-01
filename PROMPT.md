# Prompt para pegarle al Claude Code de tu hermano

Copiá y pegá esto tal cual en una sesión de Claude Code:

---

Quiero replicar un setup completo de Claude Code que está en este repo:
https://github.com/nachomdna7310/claude-code-setup

Hacé lo siguiente:

1. Cloná el repo en una carpeta temporal y leé `INSTALL.md` completo antes de tocar nada.
2. Corré `bash install.sh` desde la raíz del repo. Si algún `claude plugin install` falla,
   seguí con los demás y avisame al final cuáles fallaron.
3. Copiá las 170 skills de `skills/` a `~/.claude/skills/` (sin pisar las que ya tenga).
4. Cloná los 6 skills que son repos git aparte dentro de `~/.claude/skills/`
   (gstack, humanizalo, claude-webkit, claude-banana, skill-vault, whatsapp-agentkit).
5. Agregá los MCP servers: chrome-devtools, playwright y context7.
   Firecrawl NO lo agregues todavía: avisame que necesito mi propia API key de firecrawl.dev.
6. Instalá `jq` y `gh` con brew si no están (varios hooks necesitan jq).
7. De ruflo instalá SOLO `ruflo-core`. NO instales `ruflo-neural-trader` ni `ruflo-market-data`:
   traen un skill que ejecuta operaciones financieras reales.
8. Al final, corré `claude plugin list` y `claude mcp list` y mostrame el resultado,
   más un resumen de qué quedó instalado y qué falló.
9. Decime qué tengo que reiniciar o configurar a mano.

No modifiques ningún proyecto mío, solo la config de Claude Code en `~/.claude/`.
