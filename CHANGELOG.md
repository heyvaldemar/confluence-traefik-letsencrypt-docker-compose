# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_(no unreleased changes yet)_

## [1.0.0] - 2026-08-31

First semver release. Brings this template to the fleet standard established
in [keycloak-traefik-letsencrypt-docker-compose](https://github.com/heyvaldemar/keycloak-traefik-letsencrypt-docker-compose)
v1.2.0.

### Security

- **Confluence bumped 9.3.1 → 10.2.15.** ❗ Existing deployments should
  follow Atlassian's upgrade guidance (back up, upgrade, verify) — there
  is no downgrade. **Traefik bumped 3.2 → 3.7** (3.2's Docker client
  cannot talk to Docker Engine 29).
- **All three images pinned by `tag@sha256:digest`** (`postgres:16`
  digest-pinned; major unchanged so existing data dirs keep working).
- **Credentials untracked from git.** The tracked `.env` carried a
  generated-looking database password published on GitHub — rotate it if
  reused. `.env` is now gitignored; compose fails fast on unset values.

### Changed

- **Image pins live in the compose file as interpolation defaults**
  (`x-images` block); `.env` carries only secrets, hostnames, and
  deliberate overrides. Backup-loop variables escaped (`$$VAR`).
- README rebuilt to the fleet evaluator-first structure.

### Added

- **Deployment Verification workflow**: shellcheck + actionlint; Trivy
  scans of all three pinned images; weekly `check-pin-freshness` (digest
  drift + Confluence Docker Hub tag lag + Traefik release lag);
  deploy-and-test that boots Confluence with ephemeral credentials and
  requires `/status` to answer through Traefik.

### Fixed

- Shellcheck findings in both restore scripts.

[Unreleased]: https://github.com/heyvaldemar/confluence-traefik-letsencrypt-docker-compose/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/heyvaldemar/confluence-traefik-letsencrypt-docker-compose/releases/tag/v1.0.0
