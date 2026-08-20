# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2026-08-20

### Added

- `providers.tf` pinning `azurerm ~> 5.0` and `local ~> 2.9` — this module had no
  `required_providers` constraint before this release.
- `tags` now wired to `azurerm_automation_runbook.runbook` (the module already
  declared a `tags` input variable, but it was never passed to the resource).
- `runtime_environment_name` argument (new in azurerm >= 4.x) exposed via
  `var.runbook.runtime_environment_name`.
- `log_activity_trace_level` argument exposed via `var.runbook.log_activity_trace_level`.
- Optional `name` override for the runbook resource: `var.runbook.name` takes
  priority over the auto-generated `local.runbook-name`, so an existing runbook
  whose name diverges from the naming formula can be managed without
  destroy/recreate.
- Optional per-runbook `tags` (`var.runbook.tags`), merged over (and taking
  priority over) the module-wide `var.tags`.
- `.tflint.hcl` (root and `ESLZ/`), `.gitignore`, `.gitattributes`.
- `tests/runbook.tftest.hcl` and `tests/upgrade_compat.tftest.hcl` — `mock_provider`
  coverage for every argument/block the module exposes.
- `.github/workflows/terraform-ci.yml` — fmt/init/validate/test/tflint on every PR.
- `.github/workflows/release.yml` — creates a GitHub release on merge to `main`,
  tagged from the version pinned in `ESLZ/runbook.tf`'s own `?ref=`.

### Changed

- `azurerm_automation_runbook.runbook.description` is now wrapped in `try(..., null)`
  — it is Optional per the provider schema; the module previously referenced
  `var.runbook.description` directly, which errored for any caller that omitted it.
- `publish_content_link.hash` and `draft.content_link.hash` are now `dynamic`
  blocks gated on presence, matching the provider's Optional schema for both —
  previously `publish_content_link.hash` was always emitted (required a value
  even when the caller didn't supply one), and `draft.content_link.hash`'s
  `dynamic` block iterated the wrong path (`var.runbook.draft.hash` instead of
  `var.runbook.draft.content_link.hash`), so it never actually rendered.
- `ESLZ/runbook.tf`'s module `source` is now pinned to `?ref=v1.0.0` — it was
  previously unpinned (floating on the default branch).
- `output.runbook` now sets `sensitive = true` (Pattern 8) since it exposes the
  full resource object.

### Known blockers

- None. `azurerm 5.0.1` was confirmed as the target version by the user; no
  version substitution was required.
