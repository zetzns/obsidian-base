#!/usr/bin/env bash
# save as sanitize_filenames.sh and run with: bash sanitize_filenames.sh

set -euo pipefail

# Проходим в глубину (чтобы сначала переименовать файлы/папки внизу)
find . -depth | while IFS= read -r path; do
  name=$(basename -- "$path")
  # Убираем запрещённые символы из имени
  safe=$(echo "$name" | sed 's/[<>:"\/\\|?*]//g')
  # Если имя изменилось — делаем mv
  if [[ "$name" != "$safe" ]]; then
    dir=$(dirname -- "$path")
    # mv --protects from overwriting; уберите -i, если хотите без подтверждения
    mv -v -i -- "$path" "$dir/$safe"
  fi
done

