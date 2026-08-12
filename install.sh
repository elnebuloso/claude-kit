#!/bin/sh
# claude-kit installer — see usage() below, or run it with --help.
set -eu

TARBALL="https://codeload.github.com/elnebuloso/claude-kit/tar.gz/refs/heads/main"
SCRIPT="https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh"

usage() {
	cat <<EOF
claude-kit — copies the .claude files of a preset into the current directory.

Run this from the top of the project you want the preset in:

  curl -fsSL $SCRIPT | sh -s -- ARGUMENTS

where ARGUMENTS is one of:

  base make      install the presets "base" and "make" (name as many as you like)
  --all          install every preset there is
  --force base   overwrite files you already have — without --force they are kept
  --help         show this text
  (leave empty)  list the presets available for installing

Files are written under .claude/ exactly as they are laid out in the repository:
https://github.com/elnebuloso/claude-kit
EOF
}

force=""
all=""
presets=""
for arg in "$@"; do
	case "$arg" in
		--force) force=1 ;;
		--all) all=1 ;;
		--help|-h) usage; exit 0 ;;
		-*) printf 'unknown option: %s\n\n' "$arg" >&2; usage >&2; exit 2 ;;
		*) presets="$presets $arg" ;;
	esac
done

if [ -n "$all" ] && [ -n "$presets" ]; then
	printf -- '--all installs everything, so it takes no preset names —\n' >&2
	printf 'drop either --all or the names%s.\n\n' "$presets" >&2
	usage >&2
	exit 2
fi

dest=$(pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$TARBALL" | tar xz -C "$tmp" --strip-components=1

if [ -n "$all" ]; then
	presets=$(ls "$tmp/presets")
elif [ -z "$presets" ]; then
	printf 'claude-kit — presets available for installing:\n\n'
	ls "$tmp/presets" | sed 's/^/  /'
	printf '\nInstall one or more of them:\n\n  curl -fsSL %s | sh -s -- base make\n\n' "$SCRIPT"
	printf 'Run with --help for everything else.\n'
	exit 0
fi

# Validate every name before copying anything, so a typo cannot leave half an install behind.
for p in $presets; do
	if [ ! -d "$tmp/presets/$p/.claude" ]; then
		printf 'unknown preset: %s\navailable: %s\n' "$p" "$(ls "$tmp/presets" | tr '\n' ' ')" >&2
		exit 2
	fi
done

written=0
skipped=0
for p in $presets; do
	printf '%s:\n' "$p"
	while IFS= read -r rel; do
		[ -n "$rel" ] || continue
		if [ -e "$dest/$rel" ] && [ -z "$force" ]; then
			printf '  skip  %s (exists)\n' "$rel"
			skipped=$((skipped + 1))
			continue
		fi
		mkdir -p "$dest/$(dirname "$rel")"
		cp "$tmp/presets/$p/$rel" "$dest/$rel"
		printf '  write %s\n' "$rel"
		written=$((written + 1))
	done <<EOF
$(cd "$tmp/presets/$p" && find .claude -type f)
EOF
done

printf '\n%s file(s) written' "$written"
if [ "$skipped" -gt 0 ]; then
	printf ', %s skipped — rerun with --force to overwrite' "$skipped"
fi
printf '\n'
