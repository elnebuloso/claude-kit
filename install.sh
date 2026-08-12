#!/bin/sh
# claude-kit installer — copies the .claude files of one or more presets (or --all of them) into
# the current directory. Existing files are kept unless --force is given.
#
#   curl -fsSL https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh | sh -s -- base make
set -eu

TARBALL="https://codeload.github.com/elnebuloso/claude-kit/tar.gz/refs/heads/main"
USAGE="Usage: curl -fsSL https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh | sh -s -- [--force] <preset>...
       ... | sh -s -- [--force] --all"

force=""
all=""
presets=""
for arg in "$@"; do
	case "$arg" in
		--force) force=1 ;;
		--all) all=1 ;;
		-*) printf 'unknown option: %s\n%s\n' "$arg" "$USAGE" >&2; exit 2 ;;
		*) presets="$presets $arg" ;;
	esac
done

if [ -n "$all" ] && [ -n "$presets" ]; then
	printf -- '--all takes no preset names\n%s\n' "$USAGE" >&2
	exit 2
fi

dest=$(pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$TARBALL" | tar xz -C "$tmp" --strip-components=1

if [ -n "$all" ]; then
	presets=$(ls "$tmp/presets")
elif [ -z "$presets" ]; then
	printf 'claude-kit — available presets:\n'
	ls "$tmp/presets" | sed 's/^/  /'
	printf '\n%s\n' "$USAGE"
	printf 'See https://github.com/elnebuloso/claude-kit for what each preset contains.\n'
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
