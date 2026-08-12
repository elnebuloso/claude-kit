#!/bin/sh
# claude-kit installer — see usage() below, or run it with --help.
set -eu

TARBALL="https://codeload.github.com/elnebuloso/claude-kit/tar.gz/refs/heads/main"
SCRIPT="https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh"
TAB=$(printf '\t')

usage() {
	cat <<EOF
claude-kit — copies the .claude files of a preset into the current directory.

Run this from the top of the project you want the preset in:

  curl -fsSL $SCRIPT | sh

Called that way it asks what to install. Naming what you want skips the questions:

  base make            install the presets "base" and "make" (name as many as you like)
  --all                install every preset there is
  --force base         overwrite files you already have — without --force they are kept
  --language German    the language the prose rules are written in

Every rule that governs prose leaves the language open as <LANGUAGE>, and --language
fills it in while copying: "--language German" turns "written in <LANGUAGE>" into
"written in German". Presets carrying such a rule refuse to install without it; the
others ignore it. Asked interactively, each preset can get a language of its own.

Files are written under .claude/ exactly as they are laid out in the repository:
https://github.com/elnebuloso/claude-kit
EOF
}

# Questions go to the terminal, not to stdout — the script itself may be arriving on stdin
# through a pipe, and callers read the answers of these functions from stdout.
ask() {
	printf '%s' "$1" >/dev/tty
	read -r reply </dev/tty || exit 130
}

ask_presets() {
	printf '\nWhich presets do you want?\n\n' >/dev/tty
	printf '%s\n' "$available" | nl -w4 -s'  ' >/dev/tty
	printf '\n' >/dev/tty
	ask 'Numbers separated by spaces, or "all": '
	while :; do
		case "$reply" in
			all|All|ALL) printf '%s\n' "$available"; return ;;
		esac
		picked=""
		rejected=""
		for n in $reply; do
			case "$n" in
				''|*[!0-9]*) rejected="$rejected $n"; continue ;;
			esac
			name=$(printf '%s\n' "$available" | sed -n "${n}p")
			if [ -z "$name" ]; then
				rejected="$rejected $n"
			else
				picked="$picked$name
"
			fi
		done
		if [ -n "$rejected" ] || [ -z "$picked" ]; then
			ask "not on the list:$rejected — pick again: "
			continue
		fi
		printf '%s' "$picked"
		return
	done
}

# $1 is the question, printed above the choices.
ask_language() {
	printf '\n%s\n\n%s\n%s\n%s\n\n' "$1" '   1  German' '   2  English' '   3  something else' >/dev/tty
	while :; do
		ask 'Number: '
		case "$reply" in
			1) printf 'German\n'; return ;;
			2) printf 'English\n'; return ;;
			3) ask 'Language, spelled the way you want to read it in the rule: ' ;;
			*) continue ;;
		esac
		if [ -z "$reply" ]; then
			continue
		elif language_is_usable "$reply"; then
			printf '%s\n' "$reply"
			return
		else
			printf '%s\n' "$LANGUAGE_REJECTED" >/dev/tty
		fi
	done
}

# The language is pasted into a sed replacement below, where these three would not survive.
LANGUAGE_REJECTED='a language cannot contain | & or \'
language_is_usable() {
	case "$1" in
		''|*[\|\&\\]*) return 1 ;;
	esac
	return 0
}

preset_needs_language() {
	grep -rq '<LANGUAGE>' "$tmp/presets/$1"
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

if [ -n "$all" ] && [ -n "$presets" ]; then
	printf -- '--all installs everything, so it takes no preset names —\n' >&2
	printf 'drop either --all or the names%s.\n\n' "$presets" >&2
	usage >&2
	exit 2
fi

if [ -n "$lang" ] && ! language_is_usable "$lang"; then
	printf '%s\n' "$LANGUAGE_REJECTED" >&2
	exit 2
fi

dest=$(pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$TARBALL" | tar xz -C "$tmp" --strip-components=1
available=$(ls "$tmp/presets")

# A terminal to ask on: present when a person runs this, absent in CI and cron. The test runs in
# a subshell because a failing redirect onto ":" would take the whole script down with it.
interactive=""
if (: </dev/tty) 2>/dev/null; then
	interactive=1
fi

if [ -n "$all" ]; then
	presets=$available
elif [ -z "$presets" ] && [ -n "$interactive" ]; then
	presets=$(ask_presets)
elif [ -z "$presets" ]; then
	printf 'claude-kit — presets available for installing:\n\n'
	printf '%s\n' "$available" | sed 's/^/  /'
	printf '\nInstall one or more of them:\n\n  curl -fsSL %s | sh -s -- base make\n\n' "$SCRIPT"
	printf 'Run with --help for everything else.\n'
	exit 0
fi

# Validate every name before copying anything, so a typo cannot leave half an install behind.
for p in $presets; do
	if [ ! -d "$tmp/presets/$p/.claude" ]; then
		printf 'unknown preset: %s\navailable: %s\n' "$p" "$(printf '%s' "$available" | tr '\n' ' ')" >&2
		exit 2
	fi
done

# A preset whose rules govern prose is unusable with the placeholder left in, so settle the
# language before writing rather than leaving <LANGUAGE> behind for the reader to find.
needs=""
needs_count=0
for p in $presets; do
	if preset_needs_language "$p"; then
		needs="$needs $p"
		needs_count=$((needs_count + 1))
	fi
done

per_preset=""
if [ -n "$needs" ] && [ -z "$lang" ]; then
	if [ -z "$interactive" ]; then
		printf 'these presets write prose and need a language:%s\n' "$needs" >&2
		printf 'name one, for example: --language German\n' >&2
		exit 2
	fi
	if [ "$needs_count" -eq 1 ]; then
		lang=$(ask_language "Which language does$needs write its prose in?")
	else
		printf '\nThese presets write prose:%s\n' "$needs" >/dev/tty
		ask 'One language for all of them? [Y/n] '
		case "$reply" in
			n|N|no|No) per_preset=1 ;;
			*) lang=$(ask_language "Which language do they write their prose in?") ;;
		esac
	fi
fi

# preset and language per line, so a language containing spaces survives the loop below.
items=""
for p in $presets; do
	l=""
	if preset_needs_language "$p"; then
		if [ -n "$per_preset" ]; then
			l=$(ask_language "Which language does $p write its prose in?")
		else
			l=$lang
		fi
	fi
	items="$items$p$TAB$l
"
done

printf '\n'
written=0
skipped=0
while IFS="$TAB" read -r p l; do
	[ -n "$p" ] || continue
	if [ -n "$l" ]; then
		printf '%s (%s):\n' "$p" "$l"
	else
		printf '%s:\n' "$p"
	fi
	while IFS= read -r rel; do
		[ -n "$rel" ] || continue
		if [ -e "$dest/$rel" ] && [ -z "$force" ]; then
			printf '  skip  %s (exists)\n' "$rel"
			skipped=$((skipped + 1))
			continue
		fi
		mkdir -p "$dest/$(dirname "$rel")"
		if [ -n "$l" ]; then
			sed "s|<LANGUAGE>|$l|g" "$tmp/presets/$p/$rel" > "$dest/$rel"
		else
			cp "$tmp/presets/$p/$rel" "$dest/$rel"
		fi
		printf '  write %s\n' "$rel"
		written=$((written + 1))
	done <<EOF
$(cd "$tmp/presets/$p" && find .claude -type f)
EOF
done <<EOF
$items
EOF

printf '\n%s file(s) written' "$written"
if [ "$skipped" -gt 0 ]; then
	printf ', %s skipped — rerun with --force to overwrite' "$skipped"
fi
printf '\n'
