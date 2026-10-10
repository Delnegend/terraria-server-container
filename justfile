# Terraria Server Container: static checks and local builds.
#
# `just check` is the CI gate (see `.github/workflows/ci.yml`). It lints what
# can be linted locally and skips loudly what it cannot: hadolint needs a
# container engine, and this repo has no package manifest for an OSV job.
@default:
    just --list

# The CI gate: actionlint the workflows, shellcheck the shell scripts, hadolint
# the Dockerfile (via docker when present, skipped loudly otherwise).
check:
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v actionlint >/dev/null 2>&1; then
        actionlint .github/workflows/*.yml
    else
        echo "check: actionlint not installed, skipping workflow lint"
    fi
    shell_scripts="$(git ls-files '*.sh' ':!data/**' 2>/dev/null || true)"
    if [ -n "$shell_scripts" ]; then
        # shellcheck disable=SC2086
        shellcheck $shell_scripts
    else
        echo "check: no shell scripts tracked, skipping shellcheck"
    fi
    if command -v docker >/dev/null 2>&1; then
        docker run --rm -i hadolint/hadolint < Dockerfile
    else
        echo "check: docker not present, skipping hadolint (Dockerfile unchecked)"
    fi

# Build the image the same way the README says to.
build:
    docker compose build

# Bump the maintainer-owned release version. The server blob itself is frozen
# (terraria-server-1449 in the Dockerfile); VERSION is what `new-tag` moves.
bump version:
    #!/usr/bin/env bash
    set -euo pipefail
    NEW="{{version}}"
    # No-op signal is worktree content, not `git diff` (which ignores untracked
    # files) and not porcelain (which never shows untracked as unchanged).
    OLD="$(cat VERSION 2>/dev/null || true)"
    if [ "$NEW" = "$OLD" ]; then
        echo "error: bump $NEW is a no-op (VERSION unchanged)" >&2
        exit 1
    fi
    printf '%s\n' "$NEW" > VERSION
    git diff -- VERSION
