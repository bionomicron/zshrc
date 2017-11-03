# Set anaconda install location
ANACONDA=$HOME/.anaconda

# Begin ZGEN config
ZGEN=/home/gus/src/repos/git/zgen/zgen.zsh
ZSHRC_BASE=/home/gus/src/repos/git/zshrc

# Set name of the theme to load.
ZSH_THEME="steeef" #"sporty_256" #"kphoen" #"candy" #"agnoster" "steeef" #"candy" #"agnoster"


# load zgen
source $ZGEN

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # General System
    zgen oh-my-zsh plugins/archlinux
    zgen oh-my-zsh plugins/systemd
    zgen oh-my-zsh plugins/sudo
    # zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-syntax-highlighting

    # Docker


    # python
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/python

    # git
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/gitignore
    zgen oh-my-zsh plugins/git-extras
    zgen oh-my-zsh plugins/git-flow-avh

    # ruby
    zgen oh-my-zsh plugins/rvm
    zgen oh-my-zsh plugins/ruby
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/rake
    zgen oh-my-zsh plugins/rbenv

    # misc
    zgen oh-my-zsh plugins/tmuxinator

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    # zgen load denysdovhan/spaceship-zsh-theme spaceship
    zgen oh-my-zsh themes/$ZSH_THEME

    # save all to init script
    zgen save
fi


# ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)

#####################################################################
####### import common partials ######################################
#####################################################################

source $ZSHRC_BASE/aliases_universal.sh
source $ZSHRC_BASE/aliases_tmux.sh
source $ZSHRC_BASE/aliases_git.sh

source $ZSHRC_BASE/functions_universal.sh
source $ZSHRC_BASE/functions_git.sh

#####################################################################
####### My config stuff #############################################
#####################################################################
reset-conda-none

# #### fzf
# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh


#### Eve on Wine
alias eve='WINEARCH=win32 WINEPREFIX=~/Wine/eve32 wine ~/Wine/eve32/dosdevices/c:/EVE/Launcher/evelauncher.exe'



##### proxy stuff

bch_proxy (){
  export http_proxy=http://proxy.tch.harvard.edu:3128
  export https_proxy=$http_proxy
  export ftp_proxy=$http_proxy
  export rsync_proxy=$http_proxy
  export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
}

# start proxy by default.... for now.
bch_proxy

proxy_off(){
  unset http_proxy
  unset https_proxy
  unset ftp_proxy
  unset rsync_proxy
  echo -e "Proxy environment variable removed."
}


#### Anaconda stuff

zstyle ':completion::complete:*' use-cache 1

## If no conda env is set: set it to the one below, otherwise do nothing.
if [[ ${CONDA_ENV_PATH} == '' ]]; then
    sa none
else
    # conda_env_name=(${(ps:/:)${CONDA_ENV_PATH}})
    # source $HOME/.anaconda/bin/activate $conda_env_name[-1]
    echo "Conda environment already set: ${CONDA_ENV_PATH}."

fi

jupyter-add-conda-env (){
    old_env=$CONDA_DEFAULT_ENV
    sa $1
    python -m ipykernel install --user --name $1 --display-name "$2"
    sa $old_env
}

jupyter-slides () {
    jupyter nbconvert $1 --to slides --post serve --reveal-prefix "http://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.3.0"
}

##### DOCKER stuff
# run_conda_container () {
#     docker run --name=$1 -d bioconda/bioconda-builder /bin/bash -c "while true; do echo Hello world; sleep 1; done"
# }

conda_builder_ssh () {
    docker run --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent $1 ssh-add -l
}

bioconda-build-test () {
    docker run  -it -e http_proxy=http://proxy.tch.harvard.edu:3128/ --rm -v `pwd`:/bioconda-recipes bioconda/bioconda-builder --packages $1
}

bioconda-build-shell () {
    # docker-rm-exited-containers \
    docker run --rm --entrypoint=/bin/bash -it -e http_proxy=http://proxy.tch.harvard.edu:3128/ \
        -v  /home/gus/src/repos/git/bioconda-recipes/recipes:/bioconda-recipes \
        -v  /home/gus/src/repos/git:/gits \
        -v  /home/gus/.bioconda_docker_bin:/usr/local/bin \
        -w  / \
        bioconda/bioconda-builder
}

bioconda-build-shell-linux-anvil () {
    # docker-rm-exited-containers \
    docker run --rm --entrypoint=/bin/bash -it -e http_proxy=http://proxy.tch.harvard.edu:3128/ \
        -v  /home/gus/src/repos/git/bioconda-recipes/recipes:/bioconda-recipes \
        -v  /home/gus/src/repos/git:/gits \
        -v  /home/gus/.bioconda_docker_bin:/usr/local/bin \
        -w  / \
        condaforge/linux-anvil
}

docker-rm-exited-containers () {
    docker rm $(docker ps -a -f status=exited -q)
}

# Set terminal color abilities
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

# export TERM='xterm-color'

# # Setup PATH env vars and variants
# export PATH="${PATH}:${HOME}/bin:${HOME}/.local/bin:${HOME}/.cabal/bin:${HOME}/.linuxbrew/bin:/usr/local/bin"

# For when I need to call MY versions of things no matter what
# export PATH="${HOME}/bin:${HOME}/.local/bin:${HOME}/.luarocks/bin:${HOME}/.local/lmod/lmod/5.9.3/libexec:${HOME}/.cabal/bin:${PATH}:/usr/local/bin:/home/gus/.gem/ruby/2.4.0/bin"
export PATH="${HOME}/bin:${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cabal/bin:${PATH}:/usr/local/bin:/home/gus/.gem/ruby/2.4.0/bin"


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='micro'
else
  export EDITOR='code'
fi

# alias atom=atom-beta
alias edit=$EDITOR

export VISUAL=code

# emacs aliases
alias emc="emacsclient -c"
alias emt="emacsclient -t"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/id_rsa.pub"

export PATH="${PATH}:${HOME}/.rvm/bin" # Add RVM to PATH for scripting


# eval $(thefuck --alias)


#### Common filesystem specific locations
export UGANDA_DB=$HOME/Dropbox/uganda_data
# export PROJECTSTUFF=/home/gus/Documents/YalePostDoc/project_stuff
export SUBLIMEUSER=/home/gus/.config/sublime-text-3/Packages/User
export LINSTALLS=$HOME/.local

### Specific commonly used data locations
export GITREPOS="${HOME}/src/repos/git"
export COOKIECUTTERS="${GITREPOS}/cookiecutters"
export HUMAN_G1K_V37_FAS="/run/media/gus/Storage/BCH/data/g1k/reference_genome/human_g1k_v37.fasta"
export PROJREPOS=$GITREPOS/project-repos
export GMMGFF=$PROJREPOS/gmm-to-gff-transcripts-vs-snps
export MRICORE=$PROJREPOS/IBD-MRI_core
export IBDPORT=$PROJREPOS/prep-data-for-ibd-portal
export VEOIBD=$PROJREPOS/veoibd_misc
export VEOIBD_SYNAPSE=$PROJREPOS/veoibd-synapse-data-manager

export EUROPA=/mnt/europa
export GANYMEDE=/mnt/ganymede

#### CUPS stopped playing nice without me setting this here
# export CUPS_SERVER=localhost:631/version=1.1

#### alias to use sudo with my environment
alias sudoE="sudo -E"



#### function to suspend from terminal
susnow () {
    dbus-send --system --print-reply \
    --dest="org.freedesktop.login1" \
    /org/freedesktop/login1 \
    org.freedesktop.login1.Manager.Suspend boolean:true
}



#### Jrnl stuff

alias jw="jrnl work &"

function jwt () {
    jw < ~/Dropbox/jrnl/jrnl_work_tmpl.jnrl
    jw -1 --edit
}


#### Random alias stuff

alias dp="sudo -u dummyplug"

alias rb="systemctl reboot -i"

alias locbin="ln -st ${HOME}/.local/bin"

alias kp="killall pithos"

alias mirror_up="sudo -E reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist"

alias mirror_up_antergos="sudo cp /etc/pacman.d/antergos-mirrorlist /etc/pacman.d/antergos-mirrorlist.bk && rankmirrors -n 6 /etc/pacman.d/antergos-mirrorlist.rank_these > /tmp/antergos-mirrorlist && sudo cp /tmp/antergos-mirrorlist /etc/pacman.d/antergos-mirrorlist  && less /tmp/antergos-mirrorlist"

alias journal_dump="journalctl -xn 50"

alias clean-evo-cache="evolution --force-shutdown ; \
rm -rf ${HOME}/.cache/evolution/mail"


join-webex () {
    bash $GITREPOS/ff32-webex/run.sh $1
}

journal_since_no_avahi () {

  journalctl --since "$1 min ago" | grep -v 'avahi-daemon' | less

}


#### ISO DATE
alias DATE="date -I"
alias zulu_time="date -u +'%Y-%m-%dT%H:%M:%SZ'"
alias zulu_stamp="date -u +'%Y-%m-%dT%H.%M.%SZ'"
alias time_stamp="date +'%Y-%m-%dT%H.%M.%S'"


#### Harvard ssh shortcuts
### ORCHESTRA stuff
ORCHESTRA=wad4@orchestra.med.harvard.edu
MOUNTPOINT_ORCHESTRA="${HOME}/remote_mounts/orchestra"

alias sshOrchestra="ssh ${ORCHESTRA}"
alias sshXOrchestra="ssh -X ${ORCHESTRA}"
alias mOrchestra="sshfs ${ORCHESTRA}:/home/wad4 ${MOUNTPOINT_ORCHESTRA}"
alias uOrchestra="fusermount -u ${MOUNTPOINT_ORCHESTRA}"

### O2 stuff
O2=wad4@o2.hms.harvard.edu
MOUNTPOINT_O2="${HOME}/remote_mounts/o2"

alias sshO2="ssh ${O2}"
alias sshXO2="ssh -X ${O2}"
alias mO2="sshfs ${O2}:/home/wad4 ${MOUNTPOINT_O2}"
alias uO2="fusermount -u ${MOUNTPOINT_O2}"

#### Yale ssh shortcuts

### LOUISE stuff
LOUISE=wd238@louise.hpc.yale.edu
MOUNTPOINT_LOUISE="${HOME}/remote_mounts/louise"

alias sshLouise="ssh ${LOUISE}"
alias sshXLouise="ssh -X ${LOUISE}"
alias mLouise="sshfs ${LOUISE}:/home2/wd238 ${MOUNTPOINT_LOUISE}"
alias uLouise="fusermount -u ${MOUNTPOINT_LOUISE}"

alias mLouiseFastscratch="sshfs ${LOUISE}:/fastscratch/wd238 ${HOME}/remote_mounts/louise_fast_scratch"
alias uLouiseFastscratch="fusermount -u ${HOME}/remote_mounts/louise_fast_scratch"

alias mLouiseScratch2="sshfs ${LOUISE}:/scratch2/wd238 ${HOME}/remote_mounts/louise_scratch2"
alias uLouiseScratch2="fusermount -u ${HOME}/remote_mounts/louise_scratch2"

### BULLDOGN stuff
BULLDOGN=wd238@bulldogn1.hpc.yale.edu
MOUNTPOINT_BULLDOGN="${HOME}/remote_mounts/bulldogn"

alias sshBulldogN="ssh ${BULLDOGN}"
alias sshXBulldogN="ssh -X ${BULLDOGN}"
alias mBulldogN="sshfs ${BULLDOGN}:/ycga-ba/home/wd238 ${MOUNTPOINT_BULLDOGN}"
alias uBulldogN="fusermount -u ${MOUNTPOINT_BULLDOGN}"


### MOUNT all sshfs mount points
alias mAll="mLouise; mLouiseFastscratch; mLouiseScratch2; mBulldogN"

### UN-mount all sshfs mount points
alias uAll="uLouise; uLouiseFastscratch; uLouiseScratch2; uBulldogN"


#### Ping Google
alias pinggoogle="ping -c 5 google.com"


#### Pure git stuff


#### git flow stuff
alias gf="git flow"



#### OVERRIDE editing zshrc
alias zedit="edit $GITREPOS/zshrc"


#### Hugo aliases
alias hnew="hugo new"


#### Writing locations
export WRITINGCAVE="${GITREPOS}/markdown-docs"
alias cave="cd $WRITINGCAVE"

export DDRAD2=$HOME/MEGAsync/projects/ddRAD_phase2/repos/ddRAD_phase2


#### IPython Notebook stuff
export IPNB="${GITREPOS}/ipy_notebooks"
alias ipnb="cd ${IPNB}; jupyter notebook"
alias ipnbSERVER="cd ${IPNB}; ipython jupyter --profile=server"
alias Ipython="jupyter --matplotlib tk --gui=tk"

# Function to tunnel to correct compute node
function ipnbLOUISE(){
    ssh -f -N -L 9999:$1:9999 wd238@louise.hpc.yale.edu
}


#### etckeeper

pupdate () {

    conda_env=$CONDA_DEFAULT_ENV;

    sa none ;
    # sudo etckeeper pre-install && sudoE powerpill $1 && sudo etckeeper post-install ;
    sudoE powerpill $1 ;
    sa $conda_env ;
}


clean_pkg_cache () {

    sudo paccache -rk1;
    sudo paccache -ruk0;
}


# ### TsetseCheckout Setup
# export TSETSECHECKOUT_SECRET='32d458c4-a174-4620-8647-fc7387ba8b7d'
# export TSETSECHECKOUT_ENV="dev"
# export TSETSECHECKOUT_M1="${HOME}/Dropbox/TSETSECHECKOUT_M1"
# export TSETSECHECKOUT_M2="${HOME}/Dropbox/TSETSECHECKOUT_M2"

#### Java settings
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=setting'
export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_FONTS=/usr/share/fonts/TTF




#### STOW aliases
alias stowv="stow -v"
alias stowlink="stowv -t"
alias stowbreak="stowv -D"
alias stowrelink="stowv -Rt"

# #### Lua envvars
# export LUA_PATH='/home/gus/.luarocks/share/lua/5.2/?.lua;/home/gus/.luarocks/share/lua/5.2/?/init.lua;/usr/share/lua/5.2/?.lua;/usr/share/lua/5.2/?/init.lua;/usr/lib/lua/5.2/?.lua;/usr/lib/lua/5.2/?/init.lua;./?.lua'
# export LUA_CPATH='/home/gus/.luarocks/lib/lua/5.2/?.so;/usr/lib/lua/5.2/?.so;/usr/lib/lua/5.2/loadall.so;./?.so'
#
#
# #### Init Lmod Stuff
# source $HOME/.local/lmod/5.9.3/init/zsh
# export LMOD_CMD=$HOME/.local/lmod/5.9.3/libexec/lmod
#
# export LIBRARY_PATH='/usr/lib:/usr/lib64:/usr/lib32'
# export LD_LIBRARY_PATH=$LIBRARY_PATH
#
#
# EBUILD_MOD_DIRS="/home/gus/.local/easybuild/modules/bio:/home/gus/.local/easybuild/modules/compiler:/home/gus/.local/easybuild/modules/lang:/home/gus/.local/easybuild/modules/mpi:/home/gus/.local/easybuild/modules/numlib:/home/gus/.local/easybuild/modules/system:/home/gus/.local/easybuild/modules/toolchain:/home/gus/.local/easybuild/modules/tools:/home/gus/.local/easybuild/modules/all"
#
# export MODULEPATH=$HOME/.local/lmod/5.9.3/modulefiles:$EBUILD_MOD_DIRS
# alias md=module
#
#
# #### EasyBuild stuff
# export EASYBUILD_CONFIGFILES=$HOME/.config/easybuild/config.cfg
# export EASYBUILD_MODULES_TOOL=Lmod
# # export PYTHONPATH=/home/gus/.local/lib/python2.7/site-packages
#
# # module load EasyBuild/2.0.0
#
# alias ebgoolf-1.5.14-no-OFED="eb --try-toolchain=goolf,1.5.14-no-OFED"
# alias eb_build_alert="fembot -t 'build exited' -r 10"


#### make calling xdg-open easier
alias open="xdg-open"

#### Set dircolors

## Themes available
solarized_256dark=$HOME/.dircolors-solarized/dircolors.256dark

# ## Set the colors
eval `dircolors ${solarized_256dark}`

#### Nikola stuff
# source $HOME/.config/nikola/tabcompletion.sh


#### TMUX

### tmuxinator
source /home/gus/src/repos/git/tmuxinator/completion/tmuxinator.zsh
alias muxmain="mux start main"

#### tracker stuff
alias tctrl="tracker-control"
alias tterm="tracker-control -t"



# #### Wine set up variables
export WINEPREFIXES=$HOME/.local/share/wineprefixes
export WINEARCH=win32


# recording from the command line
alias cya="gnome-sound-recorder & ; pavucontrol &"


# virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh



### THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/gus/.gvm/bin/gvm-init.sh" ]] && source "/home/gus/.gvm/bin/gvm-init.sh"
