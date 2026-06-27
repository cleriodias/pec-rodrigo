#!/usr/bin/env bash
set -euo pipefail

deploy_lftp() {
  local target="$1"
  local username="$2"

  lftp -u "$username,$FTP_PASSWORD" "$target" <<EOF
set cmd:fail-exit yes
set net:max-retries 2
set net:timeout 30
set ftp:passive-mode on
set ssl:verify-certificate no
mkdir -p "$FTP_SERVER_DIR" || true
cd "$FTP_SERVER_DIR"
mirror -R --verbose --parallel=2 artifacts/staging .
bye
EOF
}

deploy_lftp "ftp://$FTP_SERVER:21" "$FTP_USERNAME"
echo "Deploy concluído com sucesso"
