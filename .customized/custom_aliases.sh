## Main
alias vim='/opt/homebrew/bin/nvim'; 
alias vi='/opt/homebrew/bin/nvim'; 
alias history='fc -il 1'
alias k='kubectl'
alias du='ncdu'
alias gitlog="git log --graph --all --pretty='format:%C(auto)%h %C(cyan)%ar %C(auto)%d %C(magenta)%an %C(auto)%s'"
alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"

## Others
hash -d rhcourses="/Users/jparrill/RedHat/RedHat_Consulting/RHCourses"
hash -d projects="/Users/jparrill/Projects"
hash -d dotfiles="/Users/jparrill/Projects/dotfiles/"
hash -d exercism="/Users/jparrill/Exercism/go/"
hash -d utils="/Users/jparrill/Projects/utils/"
hash -d meetups="/Users/jparrill/RedHat/Others/meetups/"

## RH Eng
hash -d eng="/Users/jparrill/RedHat/RedHat_Engineering"
hash -d cons="/Users/jparrill/RedHat/RedHat_Engineering/cons"

## RH Eng - Hypershift
hash -d hypershift="/Users/jparrill/RedHat/RedHat_Engineering/hypershift"
hash -d rosa="/Users/jparrill/RedHat/RedHat_Engineering/hypershift/ROSA"

# RH Eng - Systems Engineering
hash -d kni="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/kni"
hash -d edge="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/edge"
hash -d cnv="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/kubevirt"
hash -d upshift="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/upshift/tasks/"
hash -d mgmt="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/edge/mgmt-integration"
hash -d vz="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/edge/mgmt-integration/Verizon"
hash -d microshift="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/edge/mgmt-integration/microshift"
hash -d ztpfw="/Users/jparrill/RedHat/RedHat_Engineering/systems-engineering/edge/mgmt-integration/kubeframe/repos/ztp-pipeline-relocatable"

# RH OCM Environment
export INT_BACKPLANE_CONFIG="${HOME}/.config/backplane/integration.config.json"
export STG_BACKPLANE_CONFIG="${HOME}/.config/backplane/stage.config.json"
export PROD_BACKPLANE_CONFIG="${HOME}/.config/backplane/prod.config.json"
export OCM_API_PROD="https://api.openshift.com"
export OCM_API_INT="https://api.integration.openshift.com"
export OCM_API_STAGE="https://api.stage.openshift.com"
export PULL_SECRET="/Users/jparrill/RedHat/RedHat_Engineering/pull_secret.json"
export OCM_TOKEN="$(pass RedHat/OCMToken)"
