#!/usr/bin/env bash

# SessionStart hook for resume, clear, and compact events.
# Responsibilities:
# - persist repo-local PATH entries for later Claude Bash commands
# - surface lightweight repo context only
# - avoid launching GUI apps or mutating the environment aggressively

set -u

ROOT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
EXPECTED_THEME_DIR="$(find "${ROOT_DIR}/docroot/themes/custom" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -1)"

print_line() {
  printf '%s\n' "$1"
}

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  # Persist PATH updates so future Claude Bash commands can use local binaries.
  printf 'export PATH="$PATH:%s/node_modules/.bin"\n' "${ROOT_DIR}" >> "${CLAUDE_ENV_FILE}"
  if [ -d "${EXPECTED_THEME_DIR}/node_modules/.bin" ]; then
    printf 'export PATH="$PATH:%s/node_modules/.bin"\n' "${EXPECTED_THEME_DIR}" >> "${CLAUDE_ENV_FILE}"
  fi
fi

if [ ! -f "${ROOT_DIR}/CLAUDE.md" ]; then
  print_line "Notice: CLAUDE.md not found in current directory"
fi

if git -C "${ROOT_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH="$(git -C "${ROOT_DIR}" rev-parse --abbrev-ref HEAD 2>/dev/null || printf 'unknown')"
  STATUS_LINES="$(git -C "${ROOT_DIR}" status --short 2>/dev/null | sed -n '1,5p')"
  STATUS_COUNT="$(git -C "${ROOT_DIR}" status --short 2>/dev/null | wc -l | tr -d ' ')"

  if [ "${BRANCH}" != "develop" ]; then
    print_line "Branch: ${BRANCH}"
  fi

  if [ "${STATUS_COUNT}" -gt 0 ]; then
    print_line "Git changes: ${STATUS_COUNT}"
    if [ -n "${STATUS_LINES}" ]; then
      printf '%s\n' "${STATUS_LINES}"
    fi
  fi
fi

if [ -z "${EXPECTED_THEME_DIR}" ]; then
  print_line "Notice: no theme found under docroot/themes/custom/"
fi
