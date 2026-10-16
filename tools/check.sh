#!/bin/sh
# Run checkpatch (spelling.txt etc. are read from next to checkpatch.pl)
# Run checkpatch --strict on all driver sources (or files given as args).
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CP="$ROOT/tools/checkpatch/checkpatch.pl"
[ -x "$CP" ] || "$ROOT/tools/get-checkpatch.sh"
FILES="$*"
[ -n "$FILES" ] || FILES=$(find "$ROOT/driver" -name '*.[ch]' 2>/dev/null)
[ -n "$FILES" ] || { echo "no driver sources yet"; exit 0; }
"$CP" --no-tree --strict --terse --show-types \
	-f $FILES
