#!/bin/sh
# Fetch checkpatch.pl and its data files from mainline Linux.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)/checkpatch"
URL=https://raw.githubusercontent.com/torvalds/linux/master
mkdir -p "$DIR"
for f in scripts/checkpatch.pl scripts/spelling.txt scripts/const_structs.checkpatch .clang-format; do
	curl -fsSL "$URL/$f" -o "$DIR/$(basename "$f")"
done
chmod +x "$DIR/checkpatch.pl"
echo "checkpatch installed in $DIR"
