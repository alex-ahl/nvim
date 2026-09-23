# nvim

A personal Neovim config for .NET and infrastructure work: C#, TypeScript, Terraform,
Docker/Compose, SQL, JSON/YAML. Lua, `lazy.nvim`, one file per plugin.

## Requires

- **Neovim 0.12+**
- **git**, **make** and a C compiler
- A **Nerd Font** in the terminal

Optional, per feature:

| Tool | Needed by |
| --- | --- |
| `ripgrep` | Telescope live grep |
| `jq` | `:JsonFormat` |
| `gh` | Octo (PRs, issues, reviews) |
| `dotnet` | easy-dotnet |
| `imagemagick` + a terminal speaking the Kitty graphics protocol | image.nvim |

Mason installs the language servers and `stylua` on first run. C#'s Roslyn server comes
from easy-dotnet instead.

## Install

```sh
git clone git@github.com:alex-ahl/nvim.git ~/.config/nvim
nvim
```

`lazy.nvim` clones itself and installs everything on the first launch. `lazy-lock.json` pins
every plugin; `:Lazy sync` moves the pins, `:Lazy restore` puts them back.

## Layout

```
init.lua                  leader, Nerd Font flag, lazy.nvim bootstrap
lua/config/options.lua    editor options, filetype overrides, provider opt-outs
lua/config/keymaps.lua    global maps not owned by a plugin
lua/config/autocmds.lua   autocommands
lua/custom/plugins/*.lua  one file per plugin, imported as a directory
```

Adding a plugin means adding a file; `lazy.setup` imports the whole `custom.plugins`
directory.

## Keymaps

Leader is `<Space>`. `which-key` shows every group; the prefixes are:

| Prefix | Group |
| --- | --- |
| `<leader>g` | Git — Neogit, Diffview, blame, with hunk actions under `<leader>gh` |
| `<leader>o` | Octo — GitHub PRs, issues, reviews |
| `<leader>s` | Search — Telescope pickers |
| `<leader>d` | .NET — build, run, test, debug, solution scans |
| `<leader>e` | Errors and diagnostics |
| `<leader>j` | JSON |
| `<leader>m` | Minimap |
| `<leader>q` | Sessions — save, load, delete |
| `<leader>t` | Toggles |
| `gr*` | LSP — mostly Neovim's own defaults, plus `grR` restart and `grI` health |

Hunk actions are buffer-local, so `<leader>gh` is empty outside a git-tracked file.

## Notes

- **Formatting is `conform.nvim`**, not the LSP. Only `stylua` is wired up so far.
- **No luarocks.** `rocks` is disabled in `lazy.setup`; image.nvim uses the `magick` CLI.
