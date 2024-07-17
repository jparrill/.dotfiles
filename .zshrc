export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH}/custom"
export FZF_BASE=/opt/homebrew/bin/fzf
export FZF_DEFAULT_COMMAND="find -L"
export CUSTOMIZED=${HOME}/.customized
HIST_STAMPS="mm-dd-yyyy"
plugins=(git rust fzf pass kubectl zsh-autosuggestions oc)
ZSH_THEME="jp_russell"

source $ZSH/oh-my-zsh.sh

[[ -s "/Users/jparrill/.gvm/scripts/gvm" ]] && source "/Users/jparrill/.gvm/scripts/gvm"
source ${CUSTOMIZED}/custom_aliases.sh
source ${CUSTOMIZED}/custom_exports.sh
source ${CUSTOMIZED}/custom_functions.sh

for completion in $(ls ${CUSTOMIZED}/completions)
do
    source ${CUSTOMIZED}/completions/${completion}
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

