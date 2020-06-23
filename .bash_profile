export PATH=$HOME/bin:$PATH
export PATH=${HOME}/go/bin:$PATH
export PATH=$HOME/some/script:$PATH
export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced
#export LSCOLORS=ExGxFxdxCxDxDxxbaDecac
#export LSCOLORS=GxFxCxDxBxegedabagaced
export LSCOLORS=DxFxCxDxBxegedabagaced
#export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
#export PS1='\[\033[01;32m\]\u@:\[\033[01;36m\]\w\[\033[00m\]$(parse_git_branch)\[\033[00m\] $ '
#export PS1='\[\033[01;36m\]\w\e[38;5;204m\]$(parse_git_branch)\[\033[00m\]$ '
export PS1='\[\033[01;36m\]\w\[\033[31m\]$(parse_git_branch)\[\033[00m\]\$ '
alias ll='ls -la'
alias freemem='$HOME/some/script/memReport.py'
mcd () { mkdir -p "$1" && cd "$1"; }        # Makes new Dir and jumps inside
# Git
alias gpush='git push origin HEAD'
alias gftag='git tag -l | xargs git tag -d && git fetch --all'
# Kubernetes
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias keti='kubectl exec -ti'
alias kgp-test='kubectl get pods --context=test.us-east-2.k8s.pingidentity.net -n cicd'
alias kgp-central='kubectl get pods --context=central.us-east-2.k8s.pingidentity.net -n cicd'
alias kgp-cpl='kubectl get pods --context=test.us-east-2.k8s.pingidentity.net -n provisioners'
alias klog='kubectl logs -f'
alias klog_cpl='kubectl logs --context=test.us-east-2.k8s.pingidentity.net -n provisioners'
alias kdp='kubectl describe pods'
alias sw='$HOME/some/script/switch_kub.sh'
alias chp='$HOME/some/script/check_pod_status'
alias chpk='$HOME/some/script/check_pod_status_kompose.sh'
#source /usr/local/etc/bash_completion.d/git-completion.bash

if [ -f $(brew --prefix)/etc/bash_completion ]; then
   . $(brew --prefix)/etc/bash_completion
fi

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
#/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

function kcns() {
    namespace=$1
    if [ -z $namespace ]; then
        echo "Please provide the namespace name: 'change-ns your_namespace'"
        return 1
    fi
    kubectl config set-context $(kubectl config current-context) --namespace $namespace
}

function kns() {
	kubectl get sa default -o jsonpath='{.metadata.namespace}'
	echo
}

function valjen() {
  local jenkinsfile=$1
	curl -u mykhailozolotarenko:119565c1261e9e902d204f4f2b7b93d8e2 -X POST -F "jenkinsfile=<${jenkinsfile}" \
          https://jenkins-icecream.pingdev.tools/pipeline-model-converter/validate
}

function reload-kubeconfigs {
  # Combine kubeconfigs into ':'-delimited list as KUBECONFIG, which will be auto-merged by kubectl
  local default="${HOME}/.kube/config"
  local config_dir="${HOME}/.kube/config.d"
  local config_paths=""
  function __join { local IFS="$1"; shift; echo "$*"; }
  if [[ -n "$(ls "$config_dir")" ]]; then
    local configs=( "${config_dir}/"* )
    config_paths="$(__join : "${configs[@]}")"
  fi
  if [[ -f "$default" ]]; then
    config_paths="${default}:${config_paths}"
  fi
  export KUBECONFIG="$config_paths"
  kubectl config view --flatten > ~/.kube/merged
  export KUBECONFIG=~/.kube/merged
}

#reload-kubeconfigs
[[ -f ~/.bashrc ]] && source ~/.bashrc

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="/Users/mykhailozolotarenko/.sdkman"
#[[ -s "/Users/mykhailozolotarenko/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/mykhailozolotarenko/.sdkman/bin/sdkman-init.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export HISTTIMEFORMAT="%d/%m/%y %T "

complete -C /usr/local/bin/vault vault
