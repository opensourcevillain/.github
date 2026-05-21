#!/usr/bin/env bash
# Sync the Open Source Villain profile (profile/README.md + assets) from the
# canonical `repos` repo. GitHub can't follow cross-repo symlinks for the
# profile README, so we copy real files instead. Re-run after editing
# ../repos/README.md, then commit & push this (.github) repo.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$here/../repos"
dst="$here/profile"

# The profile uses a different title than the canonical repos README.
src_title='# Anti Limited'
dst_title='# Open Source Villain'

[ -f "$src/README.md" ] || { echo "error: $src/README.md not found" >&2; exit 1; }

mkdir -p "$dst"
rm -f  "$dst/README.md"      # drop any old symlink/file (don't write through it)
cp     "$src/README.md" "$dst/README.md"
rm -rf "$dst/assets"
cp -R  "$src/assets" "$dst/assets"

# Rewrite only the H1 title line (leaves the footer's "Anti Limited" intact).
perl -i -pe "s/^\Q${src_title}\E\$/${dst_title}/" "$dst/README.md"

echo "Synced profile/ from $src"
