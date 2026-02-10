# Neovim Keymaps

Leader key: `\`

## General

| Key | Mode | Action |
|-----|------|--------|
| `jj` | Insert | Exit insert mode |
| `Ctrl+l` | Normal | Clear search highlights |
| `\o` | Normal | Insert blank line below, stay in place |
| `Ctrl+\` | Normal, Visual | Toggle comment (vim-commentary) |

## Tabs

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+w t` | Normal | New tab |
| `Ctrl+w T` | Normal | Close tab |

## Buffers

| Key | Mode | Action |
|-----|------|--------|
| `\w` | Normal | Delete buffer |

## Clipboard (OSC52)

| Key | Mode | Action |
|-----|------|--------|
| `\c` | Normal | Yank motion to system clipboard |
| `\cc` | Normal | Yank line to system clipboard |
| `\c` | Visual | Copy selection to system clipboard |

## Black Hole Deletes

`d`, `D`, `x`, `c`, `C` are remapped to the black hole register in normal, visual, and block-select modes. Deleting never overwrites the yank register.

To cut (delete into register), use `"0d` or `"+d`.

## Telescope

| Key | Mode | Action |
|-----|------|--------|
| `\ff` | Normal | Find files |
| `\fg` | Normal | Live grep |
| `\fb` | Normal | List buffers |
| `\fh` | Normal | Help tags |

Telescope insert-mode: `Esc` closes the picker directly.

## LSP

All LSP keys are buffer-local (active when a language server attaches).

| Key | Mode | Action |
|-----|------|--------|
| `Space ,` | Normal | Previous diagnostic |
| `Space ;` | Normal | Next diagnostic |
| `Space a` | Normal | Code action |
| `Space d` | Normal | Go to definition |
| `Space f` | Normal | Format |
| `Space h` | Normal | Hover |
| `Space m` | Normal | Rename |
| `Space r` | Normal | References |
| `Space s` | Normal | Document symbols |

## Completion (nvim-cmp)

| Key | Mode | Action |
|-----|------|--------|
| `Tab` | Insert, Select | Next item / expand snippet |
| `Shift+Tab` | Insert, Select | Previous item / jump back |
| `Ctrl+Space` | Insert | Trigger completion |
| `Enter` | Insert | Confirm selection |
| `Ctrl+e` | Insert | Abort completion |
| `Ctrl+b` | Insert | Scroll docs up |
| `Ctrl+f` | Insert | Scroll docs down |

## Treesitter Text Objects

### Select

| Key | Action |
|-----|--------|
| `aa` / `ia` | Outer / inner parameter |
| `af` / `if` | Outer / inner function |

### Move

| Key | Action |
|-----|--------|
| `]a` / `[a` | Next / prev parameter start |
| `]A` / `[A` | Next / prev parameter end |
| `]f` / `[f` | Next / prev function start |
| `]F` / `[F` | Next / prev function end |
