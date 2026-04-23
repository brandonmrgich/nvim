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

| Layer | Plugin |
|---|---|
| Server installer | mason.nvim |
| Server bridge | mason-lspconfig.nvim |
| Server config | nvim-lspconfig (explicit per-server setup) |
| Completion | nvim-cmp + LuaSnip |
| Formatting | conform.nvim |
| Linting | nvim-lint |
| Java-specific | nvim-jdtls |

Server configs are defined in the `servers` table at the top of `lsp.lua`. Each server is set up explicitly — no mason dynamic handlers at runtime.

### Python Provider

The Python3 provider points to a local venv:
```
<config-dir>/venv/bin/python3   (created by install.sh)
```
`options.lua` sets `g.python3_host_prog` using `vim.fn.stdpath("config")`. `venv-selector.nvim` handles per-project venv switching at runtime.

### BigFile Guard

`core/autocmds.lua` detects files >1.5MB, sets filetype to `bigfile` and `vim.b.large_file = true`, then disables syntax highlighting. Plugins can check `vim.b.large_file` to skip heavy processing.

### SSH Clipboard

`core/options.lua` conditionally sets `clipboard = "unnamedplus"` only when `SSH_TTY` is not set, avoiding clipboard issues over SSH.

### Health Check

Run `:checkhealth bmrgich` to verify:
- Python provider availability
- Active LSP clients
- Plugin load count and startup time
- External tool availability (rg, fd, git, node, npm)

## Key Keybindings Reference

| Key | Action |
|---|---|
| `jk` (insert) | Escape to normal |
| `<leader>e` | Open Netrw |
| `<leader>ff/fr/fs/fc` | Telescope: files / recent / grep / word |
| `<leader>bash` | Floating terminal |
| `<C-h/j/k/l>` | Navigate splits (tmux-aware) |
| `gd / gR / gi / gt` | LSP: definition / references / impl / type |
| `<leader>ca / rn` | LSP: code action / rename |
| `[d / ]d` | Prev/next diagnostic |
| `[h / ]h` | Prev/next git hunk |

## Adding New Plugins

1. Add the spec to the appropriate domain file in `plugins/` (`lsp.lua`, `ui.lua`, `editing.lua`, `navigation.lua`, or `tooling.lua`).
2. No registration needed — lazy.nvim auto-imports all `.lua` files in the `plugins/` directory.

## Adding New LSP Servers

1. Add the server name + config to the `servers` table at the top of `plugins/lsp.lua`.
2. The server will be auto-installed by mason-lspconfig (`ensure_installed` is derived from the table keys).
3. If formatting is needed, add an entry in the `formatters_by_ft` table (conform.nvim section of `lsp.lua`).
4. If linting is needed, add an entry in the `linters_by_ft` table (nvim-lint section of `lsp.lua`).
