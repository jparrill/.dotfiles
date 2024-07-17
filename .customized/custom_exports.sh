# Golang
export GOPATH="${HOME}/Dev/go"
export GOBIN="${GOPATH}/bin"
export GO111MODULE="auto"
export GOPROXY="https://proxy.golang.org,direct"
export GODEBUG=x509ignoreCN=0
export GOMOD=""
export PATH="$PATH:${GOPATH//://bin:}/bin"
export GOTOOLDIR="/opt/homebrew/Cellar/go/1.18.1/libexec/pkg/tool/darwin_arm64"
export GIT_TERMINAL_PROMPT=1 
export GPG_TTY=$(tty)
export GOROOT="$(brew --prefix golang)/libexec"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Kcli
eval "$(register-python-argcomplete kcli)"

# Local
export PATH="$PATH:${HOME}/.local/bin:${HOME}/bin"

# FZF
export PATH="${PATH}:${HOME}/.fzf/bin"
export FZF_CTRL_R_OPTS="--reverse --color=fg:#888888,bg:-1,fg+:#FFFFFF,pointer:#01AB84,prompt:#01AB84,header:#01AB84,hl:#01AB84,hl+:#FFFFFF"
export FZF_DEFAULT_COMMAND="find -L ."

# Rust 
export PATH="${PATH}:${HOME}/.cargo/bin"

# Libvirt
export DYLD_FALLBACK_LIBRARY_PATH=$DYLD_FALLBACK_LIBRARY_PATH:/opt/homebrew/lib

# Mysql
export PATH="${PATH}:/opt/homebrew/opt/mysql-client/bin"

# PostgreSQL
export PATH="${PATH}:/opt/homebrew/opt/libpq/bin"

# Rancher
export PATH="${PATH}:${HOME}/.rd/bin"
