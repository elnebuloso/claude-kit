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

  base make            install the presets "base" and "make" (name as many as you like)
  --all                install every preset there is
  --force base         overwrite files you already have — without --force they are kept
  --language German    the language those presets have their rules written in
  --help               show this text
  (leave empty)        list the presets available for installing

Every rule that governs prose leaves the language open as <LANGUAGE>. --language fills
it in while copying, so "--language German" turns "written in <LANGUAGE>" into "written
in German". Presets carrying such a rule refuse to install without it; the others ignore
it. Write the language the way you want to read it in the rule.

Files are written under .claude/ exactly as they are laid out in the repository:
https://github.com/elnebuloso/claude-kit
EOF
}

force=""
all=""
lang=""
presets=""
while [ $# -gt 0 ]; do
	case "$1" in
		--force) force=1 ;;
		--all) all=1 ;;
		--help|-h) usage; exit 0 ;;
		--language)
			shift
			if [ $# -eq 0 ]; then
				printf -- '--language needs a language, for example: --language German\n' >&2
				exit 2
			fi
			lang="$1"
			;;
		--language=*) lang="${1#--language=}" ;;
		-*) printf 'unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
		*) presets="$presets $1" ;;
	esac
	shift
done

# The language is pasted into a sed replacement below, where these three would not survive.
case "$lang" in
	*[\|\&\\]*) printf 'the language name cannot contain | & or \\\n' >&2; exit 2 ;;
esac

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

# A preset whose rules govern prose is unusable with the placeholder left in, so ask before
# writing rather than leaving <LANGUAGE> behind for the reader to find.
if [ -z "$lang" ]; then
	needs=""
	for p in $presets; do
		if grep -rq '<LANGUAGE>' "$tmp/presets/$p"; then
			needs="$needs $p"
		fi
	done
	if [ -n "$needs" ]; then
		printf 'these presets write prose and need a language:%s\n' "$needs" >&2
		printf 'name one, for example: --language German\n' >&2
		exit 2
	fi
fi

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
		if [ -n "$lang" ]; then
			sed "s|<LANGUAGE>|$lang|g" "$tmp/presets/$p/$rel" > "$dest/$rel"
		else
			cp "$tmp/presets/$p/$rel" "$dest/$rel"
		fi
		printf '  write %s\n' "$rel"
		written=$((written + 1))
	done <<EOF
$(cd "$tmp/presets/$p" && find .claude -type f)
EOF
done

printf '\n%s file(s) written' "$written"
if [ -n "$lang" ]; then
	printf ', prose rules set to %s' "$lang"
fi
if [ "$skipped" -gt 0 ]; then
	printf ', %s skipped — rerun with --force to overwrite' "$skipped"
fi
printf '\n'
