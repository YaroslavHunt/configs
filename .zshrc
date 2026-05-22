# =============================================================================
# ~/.zshrc — Zsh configuration
# =============================================================================

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
# User-local binaries (pipx, cargo, manual installs, etc.)
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# -----------------------------------------------------------------------------
# Environment
# -----------------------------------------------------------------------------
# Default editor — VS Code, wait for the window to close before returning
export EDITOR='code --wait'
export VISUAL="$EDITOR"

# Locale (uncomment if your system doesn't set it elsewhere)
# export LANG=en_US.UTF-8

# -----------------------------------------------------------------------------
# Oh My Zsh
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Theme is handled by Starship below — keep OMZ theme empty
ZSH_THEME=""

# Speed up `git status` in huge repos (uncomment if needed)
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Active plugins (keep lean — too many slow down shell startup).
# zsh-syntax-highlighting MUST be loaded last for proper highlighting.
plugins=(
  git                       # git aliases + branch info
  sudo                      # double-Esc to prepend `sudo` to current command
  history                   # `h` shortcut + history helpers
  copypath                  # copy current path to clipboard
  copyfile                  # copy file contents to clipboard
  web-search                # `google`, `ddg`, ... straight from the terminal
  zsh-completions           # extra completion definitions
  fzf-tab                   # fuzzy interactive Tab menu
  zsh-autosuggestions       # fish-like inline suggestions from history
  zsh-syntax-highlighting   # colorize commands as you type
)

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000             # commands kept in memory per session
SAVEHIST=100000             # commands persisted to $HISTFILE

setopt HIST_IGNORE_ALL_DUPS # drop older duplicates of repeated commands
setopt HIST_FIND_NO_DUPS    # don't show duplicates when searching history
setopt HIST_IGNORE_SPACE    # don't record lines that start with a space
setopt HIST_REDUCE_BLANKS   # trim superfluous whitespace before saving
setopt SHARE_HISTORY        # share history across all running shells
setopt EXTENDED_HISTORY     # save timestamp + duration for each entry

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colorize matches
# zstyle ':completion:*' menu select                     # arrow-key menu

# -----------------------------------------------------------------------------
# Load Oh My Zsh (must come AFTER plugin/history/completion config)
# -----------------------------------------------------------------------------
source "$ZSH/oh-my-zsh.sh"

# -----------------------------------------------------------------------------
# fzf-tab configuration
# -----------------------------------------------------------------------------
# Disable default zsh completion menu — let fzf-tab handle it
zstyle ':completion:*' menu no
# Preview directory contents with `eza` when completing `cd`
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
# Switch between completion groups with `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# Use tmux popup if inside tmux, else regular fzf
zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse --border

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
# Modern `ls` replacement (eza) with icons and directories listed first
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh  --icons --group-directories-first'
alias la='eza -lah --icons --group-directories-first'

# Debian/Ubuntu ship these tools under suffixed names — re-alias to canonical
alias bat='batcat'
alias fd='fdfind'

# -----------------------------------------------------------------------------
# External tool integrations
# -----------------------------------------------------------------------------
# zoxide — smarter `cd` that learns your habits (`z <partial>` to jump)
eval "$(zoxide init zsh)"

# starship — cross-shell prompt (configured via ~/.config/starship.toml)
eval "$(starship init zsh)"

# fnm — Fast Node Manager: auto-switches Node version per directory
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --shell zsh --version-file-strategy=recursive --log-level=quiet)"

# corepack — manages pnpm/yarn versions shipped with Node
command -v corepack >/dev/null && corepack enable >/dev/null 2>&1

# fzf key bindings: Ctrl-R (history), Ctrl-T (files), Alt-C (cd)
source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null

# -----------------------------------------------------------------------------
# Carapace — universal completion engine (1000+ tools)
# -----------------------------------------------------------------------------
# Bridge completions from bash/fish/zsh-completions when carapace has no native definition
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
# Match completion style with the rest of the setup
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)
