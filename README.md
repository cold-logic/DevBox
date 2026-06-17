# DevBox

[![Bootstrap](https://github.com/cold-logic/DevBox/actions/workflows/test.yml/badge.svg)](https://github.com/cold-logic/DevBox/actions/workflows/test.yml)

One-line macOS developer environment setup.

## Install

Open Terminal on a fresh macOS install and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cold-logic/DevBox/main/bootstrap.sh)"
```

> **Note:** You'll be prompted for your password during the Homebrew install. Sign into the Mac App Store first if you want the MAS apps installed automatically.

## What gets installed

### Runtimes & package managers
- [mise](https://mise.jdx.dev) — polyglot runtime manager (Node, Python, Ruby, etc.)
- [uv](https://docs.astral.sh/uv/) — fast Python package manager
- [bun](https://bun.sh) — JavaScript runtime + package manager

### AWS
- [awscli](https://aws.amazon.com/cli/)
- [aws-vault](https://github.com/99designs/aws-vault) — secure credential storage

### Git & GitHub
- [gh](https://cli.github.com) — GitHub CLI
- [git-lfs](https://git-lfs.com) — large file support
- [lazygit](https://github.com/jesseduffield/lazygit) — terminal UI for git
- [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager)

### CLI tools
`bat` · `eza` · `fzf` · `jq` · `yq` · `ripgrep` · `zoxide` · `tmux` · `tldr` · `tree` · `trash` · `btop` · `wget`

### Shell enhancements (auto-added to `~/.zshrc`)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zoxide](https://github.com/ajeetdsouza/zoxide) init
- [mise](https://mise.jdx.dev) activate
- [fzf](https://github.com/junegunn/fzf) keybindings & completion

### Python dev
- [ruff](https://docs.astral.sh/ruff/) — linter & formatter
- [ty](https://github.com/astral-sh/ty) — type checker
- [pre-commit](https://pre-commit.com) · [pyright](https://github.com/microsoft/pyright) (via uv)

### Apps
| Category | Apps |
|---|---|
| Terminal | Warp, Ghostty |
| Editor / IDE | VS Code, Zed |
| AI coding agents | Claude, Codex, Codex App, Kiro, Kiro CLI |
| Browser | Arc |
| Productivity | Raycast, 1Password, Pop |
| Communication | Slack |
| Utilities | AppCleaner, PearCleaner, Suspicious Package |

### Mac App Store
- 1Password for Safari
- Magnet
- The Unarchiver
- Pure Paste
- Tailscale

### Font
- JetBrains Mono Nerd Font

## Files

| File | Purpose |
|---|---|
| `bootstrap.sh` | One-line installer — run this on a new Mac |
| `Brewfile.minimal` | The curated package list embedded in `bootstrap.sh` |

## Re-running

The script is safe to re-run. Already-installed packages are skipped and the `~/.zshrc` additions are idempotent.
