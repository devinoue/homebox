#!/usr/bin/env bash
# ref: https://xeiaso.net/notes/2024/cronchgif/
# video_minify.sh

set -e

[ ! -z "${DEBUG}" ] && set -x

# inputとoutputが指定されなければデフォルト値を設定
input="${1:-$HOME/Downloads/sc.mov}"
output="${2:-$HOME/Downloads/sc_minified.mov}"

# フレームレートを10fpsに変更し、解像度を800px以下に縮小
ffmpeg -i "${input}" -vf "fps=10,scale='if(gt(iw,800),800,iw)':'if(gt(iw,800),-2,ih)'" -c:v pam -f image2pipe - | \
    magick -delay 10 - -loop 0 -layers optimize gif:- | \
    ffmpeg -i - -movflags faststart -pix_fmt yuv420p \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${output}"