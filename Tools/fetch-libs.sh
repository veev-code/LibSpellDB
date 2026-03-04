#!/usr/bin/env bash
#
# Fetches LibSpellDB library dependencies into Libs/.
# Safe to re-run — cleans and re-fetches each library.
#
# Usage: bash Tools/fetch-libs.sh    (from the LibSpellDB addon root)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDON_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIBS_DIR="$ADDON_DIR/Libs"

TMPDIR=""
cleanup() {
    if [[ -n "$TMPDIR" && -d "$TMPDIR" ]]; then
        rm -rf "$TMPDIR"
    fi
}
trap cleanup EXIT

main() {
    echo "LibSpellDB Library Fetcher"
    echo "=========================="
    echo ""

    TMPDIR="$(mktemp -d)"

    # LibStub — extract from Ace3 repo (same source as VeevHUD)
    echo "Fetching LibStub..."
    local ace3_tmp="$TMPDIR/Ace3"
    git clone --depth 1 --quiet "https://github.com/WoWUIDev/Ace3.git" "$ace3_tmp"

    local dest="$LIBS_DIR/LibStub"
    rm -rf "$dest"
    mkdir -p "$LIBS_DIR"
    cp -r "$ace3_tmp/LibStub" "$dest"
    echo "  LibStub"

    echo ""
    echo "Done! All libraries fetched into $LIBS_DIR"
}

main
