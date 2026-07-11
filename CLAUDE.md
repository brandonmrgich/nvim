# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration written in Lua, managed by [lazy.nvim](https://github.com/folke/lazy.nvim). All configuration lives under the `bmrgich` namespace (`lua/bmrgich/`).

## Common Commands

```bash
# Install Python dependencies (pynvim for Python provider)
./install.sh

# Check Neovim health (run inside nvim)
:checkhealth bmrgich

# Update all plugins (run inside nvim)
:Lazy update

# Sync plugins to lock file (run inside nvim)
:Lazy sync

# View Mason-managed LSP/tool status (run inside nvim)
:Mason

# Profile startup (from shell)
nvim --startuptime startup.log

# Profile plugins (inside nvim)
:Lazy profile
```

## Release cadence

Every change set lands as a `vX.Y` tag plus a matching GitHub release with hand-written notes. Don't stop at the commit. Applies to every change, including doc-only edits to this file.

### Minor vs major

- **Minor bump (`vX.Y` → `vX.Y+1`)** — the default. Use for: a new plugin, a new LSP server, a keymap change, a bug fix, a version-compat patch, a clipboard/provider tweak, doc updates. Cohesive but not architectural.
  *Examples from history:* v3.1 (added git diff viewer + treesitter nil-value patch), v3.5 (keymap reshuffle + LSP/Mason robustness), v3.6 (OSC 52 clipboard inside tmux).
- **Major bump (`vX.Y` → `v(X+1).0`)** — only for structural redesigns. Use for: namespace reorganization, switching plugin manager (e.g. Packer → lazy.nvim), splitting `plugins/` into a different layout, opinionated direction shifts, breaking changes to how config files relate to each other.
  *Example from history:* v3.0 — "Large refactor for an easier-to-maintain setup" with ESLint config and CWD awareness.

When in doubt, minor. A pile of minors is fine; major bumps should feel deliberate.

### Steps after committing to `main`

1. Confirm the next number: `git tag --sort=-creatordate | head`.
2. Annotated tag: `git tag -a vX.Y -m "vX.Y: <one-line scope>" <commit>`.
3. Push tag: `git push origin vX.Y`.
4. Release: `gh release create vX.Y --title "vX.Y" --notes "..."` — match the existing prose style (lede sentence, sectioned bullets, `**Full changelog:** https://github.com/brandonmrgich/nvim/compare/<prev>...vX.Y` footer). The latest release is the canonical style reference.

## Architecture

### Entry Point & Load Order

```
init.lua
  ��� lua/bmrgich/core/init.lua   (options → keymaps → autocmds)
  → lua/bmrgich/lazy.lua        (bootstraps lazy.nvim, imports all plugin specs)
```

`init.lua` only sets `mapleader = " "` and `maplocalleader = "\\"` before requiring core and lazy, so leader keys are available to all plugins.

### Directory Structure

```
lua/bmrgich/
├── core/               # Vanilla Neovim config (no plugin dependencies)
│   ├── init.lua        # Requires options → keymaps → autocmds
│   ├���─ options.lua
│   ├── keymaps.lua
│   └── autocmds.lua
├── health.lua          # :checkhealth bmrgich
├── lazy.lua            # Lazy.nvim bootstrap + plugin imports
└── plugins/
    ���── init.lua        # Empty (lazy.nvim auto-imports all .lua files)
    ├��─ deps.lua        # Shared dependencies (plenary, web-devicons)
    ├── lsp.lua         # LSP, completion, formatting, linting, JDTLS
    ├── ui.lua          # Colorscheme, statusline, treesitter, bufferline
    ├── editing.lua     # Autopairs, commenting
    ├── navigation.lua  # Telescope, tmux-navigator, vim-maximizer
    └── tooling.lua     # Terminal, git, sessions, utilities
```

### Plugin Spec Convention

Each domain file returns a list of plugin specs:

```lua
return {
  {
    "author/plugin",
    event = "VeryLazy",   -- lazy-load trigger
    opts = {},            -- prefer opts over config where possible
  },
}
```

Rules:

- Prefer `opts` over `config` when the plugin supports it
- No `pcall` wrappers for dependencies guaranteed by lazy.nvim
- Only use `pcall` for optional external integrations
- No inline logic in spec tables

### LSP Stack

All LSP-related plugins live in `plugins/lsp.lua`:

| Layer            | Plugin                                     |
| ---------------- | ------------------------------------------ |
| Server installer | mason.nvim                                 |
| Server bridge    | mason-lspconfig.nvim                       |
| Server config    | nvim-lspconfig (explicit per-server setup) |
| Completion       | nvim-cmp + LuaSnip                         |
| Formatting       | conform.nvim                               |
| Linting          | nvim-lint                                  |
| Java-specific    | nvim-jdtls                                 |

Server configs are defined in the `servers` table at the top of `lsp.lua`.
Each server is set up explicitly — no mason dynamic handlers at runtime.

### Python Provider

The Python3 provider points to a local venv:

```sh
<config-dir>/venv/bin/python3   (created by install.sh)
```

`options.lua` sets `g.python3_host_prog` using `vim.fn.stdpath("config")`.
`venv-selector.nvim` handles per-project venv switching at runtime.

### BigFile Guard

`core/autocmds.lua` detects files >1.5MB, sets filetype to `bigfile` and `vim.b.large_file = true`, then disables syntax highlighting. Plugins can check `vim.b.large_file` to skip heavy processing.

### Clipboard

`core/options.lua` picks one of three modes:

- **SSH (`$SSH_TTY` set):** clipboard left empty — yanks stay in unnamed register, no provider attempted. Avoids the "no clipboard tool" error spam over SSH.
- **Tmux (`$TMUX` set, not SSH):** force OSC 52 provider via `vim.ui.clipboard.osc52`. Path is nvim → OSC 52 → tmux → terminal → system clipboard, robust against pbcopy/xclip auto-detection quirks. Requires `set -g set-clipboard on` in tmux and an OSC-52-capable terminal (iTerm2, kitty, WezTerm, Ghostty — *not* Apple Terminal.app).
- **Otherwise:** nvim auto-detects (pbcopy on macOS, xclip/wl-copy on Linux).

### Terminal Rendering (tmux)

Neovim's `'termsync'` option (default on) wraps TUI redraws in
synchronized-output escapes (DECSET 2026) to prevent tearing. Inside tmux
this can get stuck mid-sync, leaving the bufferline and buffer text blank
— triggers include opening a buffer or splitting a window — until an
unrelated event (switching tmux panes, or cursor movement) forces a
repaint. `:redraw!` does not fix it. Symptom is tmux-specific; a bare nvim
session outside tmux is unaffected.

Fixed in `core/options.lua`: `opt.termsync = false` when `$TMUX` is set,
disabling synchronized-output entirely inside tmux. A tmux-side attempt
first (stripping the terminfo `Sync` capability via `terminal-overrides`)
did **not** work — tmux answers nvim's DECRQM capability query as
supported regardless of that override, since it negotiates sync with inner
clients via direct escape-sequence query/response, not terminfo. See
dotfiles `v4.4` (reverts the ineffective `v4.3` tmux fix) and nvim `v3.12`.

### Health Check

Run `:checkhealth bmrgich` to verify:

- Python provider availability
- Active LSP clients
- Plugin load count and startup time
- External tool availability (rg, fd, git, node, npm)

## Key Keybindings Reference

| Key                   | Action                                     |
| --------------------- | ------------------------------------------ |
| `jk` (insert)         | Escape to normal                           |
| `<leader>e`           | Open Netrw                                 |
| `<leader>ff/fr/fs/fc` | Telescope: files / recent / grep / word    |
| `<leader>bash`        | Floating terminal                          |
| `<C-h/j/k/l>`         | Navigate splits (tmux-aware)               |
| `gd / gR / gi / gt`   | LSP: definition / references / impl / type |
| `<leader>ca / rn`     | LSP: code action / rename                  |
| `[d / ]d`             | Prev/next diagnostic                       |
| `[h / ]h`             | Prev/next git hunk                         |

## Adding New Plugins

1. Add the spec to the appropriate domain file in `plugins/` (`lsp.lua`, `ui.lua`, `editing.lua`, `navigation.lua`, or `tooling.lua`).
2. No registration needed — lazy.nvim auto-imports all `.lua` files in the `plugins/` directory.

## Adding New LSP Servers

1. Add the server name + config to the `servers` table at the top of `plugins/lsp.lua`.
2. The server will be auto-installed by mason-lspconfig (`ensure_installed` is derived from the table keys).
3. If formatting is needed, add an entry in the `formatters_by_ft` table (conform.nvim section of `lsp.lua`).
4. If linting is needed, add an entry in the `linters_by_ft` table (nvim-lint section of `lsp.lua`).
