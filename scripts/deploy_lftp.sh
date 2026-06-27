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

USER_CANDIDATES=(
  "$FTP_USERNAME"
  "${FTP_USERNAME}@paoecafe83.com.br"
  "ftp.${FTP_USERNAME}"
)

TARGETS=(
  "ftps://$FTP_SERVER:990"
  "ftp://$FTP_SERVER:21"
)

for username in "${USER_CANDIDATES[@]}"; do
  for target in "${TARGETS[@]}"; do
    echo "Tentando deploy como $username em $target"
    if deploy_lftp "$target" "$username"; then
      echo "Deploy concluído com sucesso"
      exit 0
    fi
  done
done

echo "Falha ao publicar na KingHost com todos os usuários e protocolos testados"
exit 1
