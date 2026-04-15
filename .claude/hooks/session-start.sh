#!/usr/bin/env bash

# SessionStart hook for fresh Claude launches.
# Responsibilities:
# - persist repo-local PATH entries for later Claude Bash commands
# - surface compact repo context
# - ensure Docker Desktop and DDEV are ready on initial startup

set -u

ROOT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
DDEV_CONFIG="${ROOT_DIR}/.ddev/config.yaml"
EXPECTED_THEME_DIR="$(find "${ROOT_DIR}/docroot/themes/custom" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -1)"
DOCKER_READY=1

print_line() {
  printf '%s\n' "$1"
}

persist_env() {
  # Persist PATH updates so future Claude Bash commands can use local binaries.
  if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
    printf 'export PATH="$PATH:%s/node_modules/.bin"\n' "${ROOT_DIR}" >> "${CLAUDE_ENV_FILE}"
    if [ -d "${EXPECTED_THEME_DIR}/node_modules/.bin" ]; then
      printf 'export PATH="$PATH:%s/node_modules/.bin"\n' "${EXPECTED_THEME_DIR}" >> "${CLAUDE_ENV_FILE}"
    fi
  fi
}

print_repo_context() {
  # Keep startup context short and high-signal.
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
}

persist_env
print_repo_context

if [ -f "${DDEV_CONFIG}" ]; then
  if command -v docker >/dev/null 2>&1; then
    if ! docker info >/dev/null 2>&1; then
      DOCKER_READY=0
      # On a fresh startup, it is worth trying to recover by launching Docker.
      if open -a Docker >/dev/null 2>&1; then
        print_line "Docker Desktop: starting"
        for _ in 1 2 3 4 5 6 7 8 9 10; do
          sleep 2
          if docker info >/dev/null 2>&1; then
            DOCKER_READY=1
            print_line "Docker Desktop: ready"
            break
          fi
        done
      else
        print_line "Docker Desktop: failed to launch"
      fi

      if [ "${DOCKER_READY}" -ne 1 ]; then
        print_line "Docker Desktop: still not ready"
      fi
    fi
  else
    print_line "Docker: command not found"
    DOCKER_READY=0
  fi

  if [ "${DOCKER_READY}" -eq 1 ] && command -v ddev >/dev/null 2>&1; then
    # ddev status still works for stopped projects, so check for a healthy web service.
    DDEV_STATUS="$(cd "${ROOT_DIR}" && ddev status 2>/dev/null)"
    if ! printf '%s' "${DDEV_STATUS}" | grep -q 'web[[:space:]]*OK'; then
      if (cd "${ROOT_DIR}" && ddev start >/dev/null 2>&1); then
        print_line "DDEV: started"
      else
        print_line "DDEV: failed to start"
      fi
    fi
  elif [ "${DOCKER_READY}" -eq 1 ]; then
    print_line "DDEV: command not found"
  fi
fi
