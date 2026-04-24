# REFACTOR PLAN V2 — Stability, Diagnostics UX, and Modernization

## Goals

1. Eliminate remaining runtime bugs (Tree-sitter crash)
2. Establish a **clean, non-intrusive diagnostics UX**
3. Upgrade ecosystem to modern, stable versions
4. Improve project-aware behavior (TurboRepo, ESLint, TS)
5. Reduce maintenance overhead long-term

---

## 1. Critical Bug Fix: Tree-sitter Crash

### Problem

attempt to call method 'range' (a nil value)

This is almost always caused by:

- Parser/runtime mismatch
- Outdated queries
- Neovim version incompatibility

### Actions

1. **Force reinstall all parsers**

```vim
:TSUpdate
:TSUninstall all
:TSInstall all
Pin nvim-treesitter to a stable commit
Avoid latest HEAD instability.
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  version = false, -- use commit pin instead
}

Then lock via lazy-lock.json.

Disable problematic modules initially
highlight = {
  enable = true,
  additional_vim_regex_highlighting = false,
},
indent = {
  enable = false, -- often source of breakage
},
Add safe guard:
vim.treesitter.start = (function(orig)
  return function(...)
    local ok = pcall(orig, ...)
    if not ok then
      vim.notify("Treesitter failed to start", vim.log.levels.WARN)
    end
  end
end)(vim.treesitter.start)
2. Diagnostics UX (Balanced Model)
Problem
Popups are intrusive and steal focus
Inline diagnostics can overflow / become unreadable
Target UX (Community Best Practice)
Element	Behavior
Inline diagnostics	Short, truncated
Virtual text	Minimal
Float window	On-demand + auto on hover (delayed)
No auto focus	Never enter insert disruption
Implementation
Global Diagnostic Config
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "●",
    format = function(diagnostic)
      return diagnostic.message:sub(1, 80) -- truncate long messages
    end,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    focusable = false,
    style = "minimal",
  },
})
Auto Hover (Non-Intrusive)
vim.o.updatetime = 250

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
    })
  end,
})
Manual Keybind (Primary Interaction)
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { focus = false })
end)
Optional: Better Rendering via Plugin

Add:

{
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  opts = {},
}

This improves wrapping and readability vs native virtual_text.

3. LSP & Tooling Modernization
Replace Deprecated Patterns
Ensure no deprecated APIs:
Remove vim.lsp.buf.formatting → use vim.lsp.buf.format
Avoid legacy handlers
Standard LSP Setup Pattern
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig")[server].setup({
  capabilities = capabilities,
})
Mason

Ensure:

require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = true,
})
4. ESLint + TurboRepo Awareness
Problem

Multiple ESLint configs across apps → conflicts

Solution

Use project-local resolution only.

nvim-lint config
require("lint").linters.eslint_d = {
  cwd = function()
    return vim.fn.getcwd()
  end,
}
Ensure:
No global fallback ESLint config
Respect nearest .eslintrc / flat config
5. TypeScript / Monorepo Improvements
Add
{
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
}

Benefits:

Better TS performance vs tsserver
Native monorepo awareness
Improved imports
6. Treesitter Stability Enhancements
Limit installed parsers

Avoid "install all":

ensure_installed = {
  "lua",
  "typescript",
  "tsx",
  "javascript",
  "json",
  "bash",
  "markdown",
}
Disable for large files (already supported)

Ensure integration:

if vim.b.large_file then
  return
end
7. Plugin Modernization
Audit and upgrade:

Run:

:Lazy update
:checkhealth

Then:

Remove unmaintained plugins
Prefer:
mini.nvim modules (stable, low-maintenance)
folke ecosystem (well maintained)
8. Reduce Editor Noise
Disable automatic popups from completion
completion = {
  autocomplete = false,
}

Manual trigger only (<C-Space>)

Disable LSP hover auto-trigger

Only allow diagnostics hover (not LSP hover spam)

9. Claude Code Workflow Improvements
Add keybinding
vim.keymap.set("n", "<leader>ac", ":ClaudeCode<CR>")
Ensure:
Floating terminals do not steal focus
No insert mode forced by plugins
10. Health + Debugging Improvements

Enhance health.lua:

Check:

Treesitter parser status
LSP attached buffers
Node / npm / pnpm presence
eslint_d availability
11. Lockfile Discipline

After stabilization:

:Lazy sync
git commit lazy-lock.json

Avoid frequent updates unless needed.

Final Result

After this plan:

Tree-sitter crash resolved
Diagnostics are:
visible
readable
non-intrusive
Monorepo tooling behaves correctly
Editor noise significantly reduced
Config is modern, stable, and maintainable
Guiding Principle Going Forward

Prefer stability over novelty.
Prefer explicit configuration over magic.
Prefer fewer plugins with stronger guarantees.
```
