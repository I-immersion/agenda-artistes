#!/bin/bash
# deployer.command — Agenda Artistes → GitHub Pages (i-immersion/agenda-artistes)
# Double-clic : récupère le dernier index du projet dans Téléchargements,
# le copie dans ce dossier (remplace l'ancien), puis commit + push.

cd "$(dirname "$0")"

DOWNLOADS="$HOME/Downloads"
SIGNATURE="agenda_artistes"   # on ne ramène QUE les index de ce projet

echo "📦 Déploiement Agenda Artistes"
echo "Dossier du repo : $(pwd)"
echo ""

# 1) Chercher le index*.html le plus récent (du projet) dans Téléchargements
SRC=""
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if grep -q "$SIGNATURE" "$f" 2>/dev/null; then SRC="$f"; break; fi
done < <(ls -t "$DOWNLOADS"/index*.html 2>/dev/null)

if [ -n "$SRC" ]; then
  echo "📥 Nouvel index trouvé : $(basename "$SRC")"
  cp "$SRC" index.html
  echo "   → copié dans le dossier (ancien remplacé)."
else
  echo "ℹ️  Aucun nouvel index du projet dans Téléchargements."
  echo "   Je pousse l'index.html déjà présent dans le dossier."
fi
echo ""

VERSION=$(grep -oE 'v[0-9]+\.[0-9]+' index.html 2>/dev/null | head -1)
echo "Version du fichier à déployer : ${VERSION:-inconnue}"
echo ""

# 2) Commit + push
git add -A
if git diff --cached --quiet; then
  echo "ℹ️  Aucun changement par rapport à ce qui est déjà en ligne."
else
  git commit -m "${VERSION:-maj} — $(date '+%Y-%m-%d %H:%M')"
fi
git push
echo ""
echo "✅ Terminé."
echo "🔗 https://i-immersion.github.io/agenda-artistes/"
echo "   Patiente ~1 min, puis recharge en navigation privée."
echo ""
echo "Tu peux fermer cette fenêtre."
