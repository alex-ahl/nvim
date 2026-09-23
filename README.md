# nvim

A personal Neovim config for .NET and infrastructure work: C#, TypeScript, Terraform,
Docker/Compose, SQL, JSON/YAML. Lua, `lazy.nvim`, one file per plugin.

## Requires

- **Neovim 0.12+** — `grR` calls the built-in `:lsp` command, which does not exist earlier.
- **git**, **make** and a C compiler — `lazy.nvim` bootstraps itself, and `telescope-fzf-native`
  and LuaSnip build native components.
- A **Nerd Font** in the terminal (`vim.g.have_nerd_font` is on; icons degrade without it).

Optional, per feature:

| Tool | Needed by |
| --- | --- |
| `ripgrep` | Telescope live grep |
| `jq` | `:JsonFormat` |
| `gh` | Octo (PRs, issues, reviews) |
| `dotnet` | easy-dotnet |
| `imagemagick` + a terminal speaking the Kitty graphics protocol | image.nvim |

Mason installs the language servers and `stylua` on first run. C# is the exception --
its Roslyn server comes from easy-dotnet, not Mason.

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

Adding a plugin means adding a file — `lazy.setup` imports the whole `custom.plugins`
directory, so nothing else needs touching.

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

Git keys live under one prefix on purpose: hunk actions are buffer-local, so `<leader>g` shows
fewer entries outside a git-tracked file.

## Notes

- **Mason owns the toolchain.** Servers are declared in `lspconfig.lua`; `mason-tool-installer`
  installs whatever that table names.
- **Formatting is `conform.nvim`**, not the LSP. Only `stylua` is wired up so far.
- **No luarocks.** `rocks` is disabled in `lazy.setup` to silence the Lua 5.1 health warnings;
  image.nvim uses the `magick` CLI rather than the luarock.
