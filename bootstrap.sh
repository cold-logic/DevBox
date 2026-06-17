#!/usr/bin/env bash
# =============================================================================
# macOS Developer Bootstrap
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cold-logic/DevBox/main/bootstrap.sh)"
# =============================================================================
set -euo pipefail

# ── Colours ───────────────────────────────────────────────────────────────────
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

info()    { echo -e "\n${CYAN}${BOLD}▶ $*${RESET}"; }
success() { echo -e "${GREEN}✓ $*${RESET}"; }
warn()    { echo -e "${YELLOW}⚠ $*${RESET}"; }
die()     { echo -e "${RED}✗ $*${RESET}" >&2; exit 1; }

# ── Sanity checks ─────────────────────────────────────────────────────────────
[[ "$(uname -s)" == "Darwin" ]] || die "This script is macOS only."

# ── Homebrew ──────────────────────────────────────────────────────────────────
info "Homebrew"
if command -v brew &>/dev/null; then
  success "Already installed — updating"
  brew update --quiet
else
  warn "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for this session (installer adds it to ~/.zprofile for future sessions)
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  success "Homebrew installed"
fi

# ── Write embedded Brewfile to a temp file ────────────────────────────────────
BREWFILE=$(mktemp /tmp/Brewfile.XXXXXX)
trap 'rm -f "$BREWFILE"' EXIT

cat > "$BREWFILE" << 'BREWFILE_EOF'
# ── Runtime & Package Managers ────────────────────────────────────────────────
brew "mise"          # Polyglot runtime manager (node, python, ruby, etc.)
brew "uv"            # Fast Python package manager / tool runner
brew "bun"           # JavaScript runtime + package manager

# ── AWS ───────────────────────────────────────────────────────────────────────
brew "awscli"
brew "aws-vault"     # Secure AWS credential storage

# ── Git & GitHub ──────────────────────────────────────────────────────────────
brew "gh"            # GitHub CLI
brew "git-lfs"       # Large file support
brew "lazygit"       # TUI git client
cask "git-credential-manager"

# ── CLI Quality of Life ───────────────────────────────────────────────────────
brew "bat"           # Better cat
brew "eza"           # Better ls
brew "fzf"           # Fuzzy finder
brew "jq"            # JSON processor
brew "yq"            # YAML/JSON/TOML processor
brew "ripgrep"       # Fast grep
brew "zoxide"        # Smarter cd
brew "tmux"          # Terminal multiplexer
brew "tldr"          # Simplified man pages
brew "tree"          # Directory tree view
brew "trash"         # Safe rm
brew "btop"          # Resource monitor
brew "wget"
brew "mas"           # Mac App Store CLI

# ── Shell Enhancements ────────────────────────────────────────────────────────
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# ── Python Dev ────────────────────────────────────────────────────────────────
brew "ruff"          # Linter/formatter
brew "ty"            # Type checker

# ── Fonts ─────────────────────────────────────────────────────────────────────
cask "font-jetbrains-mono-nerd-font"

# ── Terminal ──────────────────────────────────────────────────────────────────
cask "warp"
cask "ghostty"

# ── Editors / IDEs ────────────────────────────────────────────────────────────
cask "visual-studio-code"
cask "zed"

# ── AI Coding Agents ──────────────────────────────────────────────────────────
cask "claude"
cask "codex"
cask "codex-app"
cask "kiro"
cask "kiro-cli"

# ── Browser ───────────────────────────────────────────────────────────────────
cask "arc"

# ── Productivity ──────────────────────────────────────────────────────────────
cask "raycast"
cask "1password"
cask "pop-app"

# ── Communication ─────────────────────────────────────────────────────────────
cask "slack"

# ── System Utilities ──────────────────────────────────────────────────────────
cask "appcleaner"
cask "pearcleaner"
cask "suspicious-package"

# ── Mac App Store ─────────────────────────────────────────────────────────────
mas "1Password for Safari", id: 1569813296
mas "Magnet", id: 441258766
mas "The Unarchiver", id: 425424353
mas "Pure Paste", id: 1611378436
mas "Tailscale", id: 1475387142

# ── uv Tools ──────────────────────────────────────────────────────────────────
uv "pre-commit"
uv "pyright"
BREWFILE_EOF

# ── Install packages ──────────────────────────────────────────────────────────
info "Installing packages (this will take a while)..."
brew bundle install --file "$BREWFILE" --no-lock
success "All packages installed"

# ── Shell configuration (~/.zshrc) ────────────────────────────────────────────
info "Configuring ~/.zshrc"
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

# Append a line only if it isn't already present
append_if_missing() {
  local line="$1"
  grep -qxF "$line" "$ZSHRC" 2>/dev/null || echo "$line" >> "$ZSHRC"
}

BREW_PREFIX="$(brew --prefix)"

append_if_missing ""
append_if_missing "# ── Bootstrap additions ───────────────────────────────────────────────────────"

# zsh-autosuggestions
append_if_missing "source \"${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh\""

# zsh-syntax-highlighting (must come last among zsh plugins)
append_if_missing "source \"${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\""

# zoxide (smarter cd)
append_if_missing 'eval "$(zoxide init zsh)"'

# mise (runtime version manager)
append_if_missing 'eval "$(mise activate zsh)"'

# fzf (fuzzy finder keybindings + completion)
append_if_missing 'source <(fzf --zsh)'

success "$HOME/.zshrc updated"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}Bootstrap complete!${RESET}"
echo -e "Run ${CYAN}source ~/.zshrc${RESET} or open a new terminal to apply shell changes."
echo ""
