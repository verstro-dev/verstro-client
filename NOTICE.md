# NOTICE

This repository (`verstro-client`) is a private fork of
[FlClash](https://github.com/chen08209/FlClash) by chen08209.

## Upstream license

GNU General Public License version 3.0 (or, at your option, any later
version). The complete original LICENSE file is preserved unchanged
at the repository root.

FlClash does not impose any additional restrictions beyond stock
GPLv3. Unlike Karing (which adds a name-restriction clause), there
is no name-restriction on Verstro fork.

## Verstro fork commitments

1. **Source disclosure on distribution.** This repository will be made
   public at or before the first public distribution of any compiled
   binary (currently scheduled for Phase 2.6 — website downloads and
   TestFlight public link). This satisfies GPLv3's obligation to
   provide source alongside binaries.
2. **Attribution preserved.** The original `LICENSE` is kept
   unmodified. Substantial Verstro modifications are tracked in this
   repository's git history; a summary will be added here at public
   release.

## Branch policy

| Branch            | Purpose                                                            |
|-------------------|--------------------------------------------------------------------|
| `main`            | Pristine snapshot of FlClash upstream at import time (2026-05-28). Do not commit Verstro changes here. |
| `dev`             | Verstro-specific changes. Default working branch. **Replaces** `origin/dev` (which is FlClash upstream's dev, force-pushed on first Verstro push). |
| `upstream-rebase` | Periodically rebased against `upstream/main`, then merged into `dev`. |

## Pivot history

This is the second fork attempt. The first attempt (2026-05-28
morning) forked KaringX/karing but was abandoned because Karing
depends on a private sibling `vpn-service` repository that is not
publicly available on GitHub (404), making external builds
impossible. KaringX team's strategy is GUI-public + native-core-
private. See `docs/decisions.md` § why-flclash-pivot in the parent
(Verstro) repository for full context.

## Maintainer

Verstro project (verstro.com / verstro.dev / verstro.io)

Last updated: 2026-05-28
