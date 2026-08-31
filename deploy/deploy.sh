#!/bin/bash
# Выкладка robertfitchell.online на training-vps (Новосибирск).
# Запуск с Mac:  bash ~/Desktop/Проекты/fitchell-online/deploy/deploy.sh
set -e

SRC="/Users/De_Colt/Desktop/Проекты/fitchell-online/"
HOST="training-vps"
DEST="/var/www/robertfitchell-online/"

rsync -az --delete \
  --exclude '.git' --exclude '.claude' --exclude 'deploy' \
  --exclude 'CNAME' --exclude '.gitignore' --exclude '.DS_Store' \
  --exclude '*.docx' --exclude '*.pages' \
  "$SRC" "$HOST:$DEST"

# права выставляем на сервере: старый rsync с Mac тащит сюда локальные права
ssh "$HOST" 'chown -R www-data:www-data /var/www/robertfitchell-online \
  && find /var/www/robertfitchell-online -type d -exec chmod 755 {} + \
  && find /var/www/robertfitchell-online -type f -exec chmod 644 {} + \
  && nginx -t && systemctl reload nginx'
echo "Выложено: https://robertfitchell.online"
