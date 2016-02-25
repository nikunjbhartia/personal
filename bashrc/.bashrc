# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias kfd='cd /Applications/kafka'
alias kfss='./bin/kafka-server-start.sh config/server.properties'
alias kfct='./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic $topic'
alias kflt='./bin/kafka-topics.sh --list --zookeeper localhost:2181'
alias zkss='./bin/zookeeper-server-start.sh config/zookeeper.properties'
alias kfsp='./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic $topic'
alias kfsc='./bin/kafka-console-consumer.sh --zookeeper localhost:2181 --from-beginning --topic $topic'

alias shopod='cd ~/Documents/shopo/'
alias ejbd='cd /Applications/ejabberd-15.04'
alias ejbss='./bin/ejabberdctl start'
alias ejbdebug='./bin/ejabberdctl debug'
alias ejblogs='tail -f logs/ejabberd.log'
alias compileAllErl='ls | grep erl | while read line;do echo "--- compiling $line ---" && compile $line;done'



alias gfetchall='declare -a arr=("ChatClient" "AccountsClient" "NotificationsClient" "OffersClient" "ProductsClient" "SearchClient" "Accounts" "Chat" "shopochat-erl");for line in ${arr[@]}; do echo $line && cd $line && git fetch --all && cd ..; done'

alias gpullall='declare -a arr=("ChatClient" "AccountsClient" "NotificationsClient" "OffersClient" "ProductsClient" "SearchClient" "Accounts" "Chat" "shopochat-erl" "Gateway" "seller" "feeds-client" "shopo-common");for line in ${arr[@]}; do echo $line && cd $line && git pull && cd ..; done'

alias mvnci='declare -a arr=("ChatClient" "AccountsClient" "NotificationsClient" "OffersClient" "ProductsClient" "SearchClient" "feeds-client" "shopo-common" "Chat" "Accounts");for line in ${arr[@]}; do echo  "***** MVN CLEAN INSTALL $line ***** "  && cd $line && mvn clean install && cd ..; done'


alias tcatchatd='cd /opt/tomcat-chat/'
alias tcataccountsd='cd /opt/tomcat-accounts/'
alias tcatproductsd='cd /opt/tomcat-products/'
alias tcss='./bin/catalina.sh start'
alias tclogs='tail -f logs/catalina.out'
alias dploychats="shopod;cd ChatClient;mvn clean install;cd ../AccountsClient;mvn clean install;cd../NotificationsClient;mvn clean install;cd ../Chat;mvn clean package;scp target/ROOT.war dtc:~;ssh dtc ./dploy_script.sh"

alias forticlient='cd /Applications/forticlient/forticlientsslvpn/ && ./forticlientsslvpn'
alias pkillshopo='declare -a arr=("kafka" "zookeeper" "tomcat" "ejabberd");for line in ${arr[@]}; do echo $line && sudo pkill -cef line; done'


alias startBrowserTabs='declare -a arr=("https://www.facebook.com/" "web.whatsapp.com" "https://www.linkedin.com/" "https://shopo.slack.com/messages" "https://mail.google.com/mail/u/0/#inbox" "https://mail.google.com/mail/u/1/#inbox");for line in ${arr[@]};do chromium-browser $line ;done'

alias startMyOfficeDay='echo "opening required browser sessions" && startBrowserTabs && echo "pulling all martmobi git repos" && shopod && gpullall && terminator -e sts & && terminator -e dploychats & && terminator -e dployerl &'

alias sdb="mysql -usk17312IU -p'SK#shop@1' -h52.74.115.166"
alias ddb="mysql -u root -p'123tre@$ureShopo.456' -h 52.74.132.72"
alias ldb="mysql -uroot -ppassword"

erlangcompile() {
  erlc -I /Applications/ejabberd-15.04/lib/ejabberd-15.04/include -DNO_EXT_LIB -pa /Applications/ejabberd-15.04/lib/ejabberd-15.04/ebin $1
}
alias compile=erlangcompile

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export REBAR_TOP="/Applications/rebar"
export PATH="$REBAR_TOP:$PATH"

export ERL_TOP="/Applications/erlang17.5/bin"
export PATH="$ERL_TOP:$PATH"

export J2SDKDIR=/usr/lib/jvm/oracle_jdk8
export J2SDKDIR=/usr/lib/jvm/oracle_jdk8
export J2REDIR=/usr/lib/jvm/oracle_jdk8/jre
export PATH=/usr/lib/jvm/oracle_jdk8/bin:/usr/lib/jvm/oracle_jdk8/db/bin:/usr/lib/jvm/oracle_jdk8/jre/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/oracle_jdk8
export DERBY_HOME=/usr/lib/jvm/oracle_jdk8/db

#=======================================



function parse_git_branch {
git branch --no-color 2> /dev/null | sed -e '/^[^​*]/d' -e 's/*​ \(.*\)/(\1)/'
}

function proml {
local BLUE="\[\033[0;34m\]"
local RED="\[\033[0;31m\]"
local LIGHT_RED="\[\033[1;31m\]"
local GREEN="\[\033[0;32m\]"
local LIGHT_GREEN="\[\033[1;32m\]"
local WHITE="\[\033[00m\]"
local BOLD_WHITE="\[\033[1;37m\]"
local LIGHT_GRAY="\[\033[0;37m\]"
local LIGHT_GRAY="\[\033[0;37m\]"
case $TERM in
    xterm*)
        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
        ;;
    *)
        TITLEBAR=""
        ;;
esac

PS1="$GREEN\$(parse_git_branch)$WHITE[\u:\w]\$ "
PS2='> '
PS4='+ '

}


function git_branches()
{
    if [[ -z "$1" ]]; then
        echo "Usage: $FUNCNAME <dir>" >&2
        return 1
    fi

    if [[ ! -d "$1" ]]; then
        echo "Invalid dir specified: '${1}'"
        return 1
    fi

    # Subshell so we don't end up in a different dir than where we started.
    (
        cd "$1"
        for sub in *; do
            [[ -d "${sub}/.git" ]] || continue
            echo -e "\033[0;32m$sub \033[0;31m[$(cd "$sub"; git  branch | grep '^\*' | cut -d' ' -f2)]"
        done
    )
}

alias list="git_branches ."

proml

function dployerl(){
   shopod;
   cd shopochat-erl/;
   rm *.beam;
   compileAllErl
   if [ "$1" == "staging" ]; then
       echo "--------- Deploying Shopo erlang on ejabberd node Hostname 52.74.89.13 ----------"
        scp *.beam sej1:/home/nb16393/beam/
        shopod
        cat dploy_scripts/dploy_erl.sh | ssh -t -t sej1 "sudo sh"
        terminator -T "sej1 ejabberd logs" -e ssh sej1 tail -f /apps/ejabberd-15.04/logs/ejabberd.log &
        echo "--------- Deploying Shopo erlang on ejabberd node Hostname 52.74.18.97 ---------- "
        shopod
        cd shopochat-erl/
        scp *.beam sej2:/home/nb16393/beam/
        shopod
        cat dploy_scripts/dploy_erl.sh | ssh -t -t sej2 "sudo sh"
        terminator -T "sej2 ejabberd logs" -e ssh sej2 tail -f /apps/ejabberd-15.04/logs/ejabberd.log &
    else
       echo "---------------------- Deploying Shopo erlang on dev -----------------------------"
        scp *.beam dej:/home/nb16393/beam/
        shopod
        cat dploy_scripts/dploy_erl.sh | ssh -t -t dej "sudo sh"
        terminator -T "dej ejabberd logs" -e ssh dej tail -f /apps/ejabberd-15.04/logs/ejabberd.log &
    fi
}