export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=~/.local/bin:$PATH
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_222)

# PS1="\w \[\e[1;31m\]\$(parse_git_branch)\[\e[0m\]$\n "

alias sha='git rev-parse HEAD'
alias gcm='git commit -m'
alias gco='git checkout'
alias gs='git status'
alias ga='git add'
alias gp='git pull'
alias gpu='git push'
alias mg='git merge'

aws_login()
{
    local profile=$1
    eval $(aws ecr get-login --no-include-email --region us-east-1 --profile $profile)
}

# Docker sandbox commands
dbuild()
{
    local repository=$1
    local dockerfile_path='/Users/tealiumemployee/tealium-workspace/python-platform/tealium_udh'
    docker build -t $repository $dockerfile_path
}

dtag() 
{
    local repository=$1
    local image_tag=$2
    local environment=$3
    docker tag $repository:latest $environment.dkr.ecr.us-east-1.amazonaws.com/$repository:$image_tag
}

dpush() 
{
    local repository=$1
    local image_tag=$2
    local environment=$3
    docker push $environment.dkr.ecr.us-east-1.amazonaws.com/$repository:$image_tag
}

dockerbtp() 
{
    # default values
    local repository='dev-elainechao'
    local image_tag='ecs-test-2'
    local environment='516332124665' #sandbox

    while [ $# -gt 0 ]
    do
        case "$1" in
            --repository | -r)
                repository=$2
                ;;
            --tag | -t)
                image_tag=$2
                ;;
            --environment | -e)
                if [ "$2" -eq "sandbox" ]; then
                    environment='516332124665'
                elif [ "$2" -eq "preprod" ]; then
                    environment='916122220265'
                fi
                ;;
            *)
                echo "usage: dflow [options]"
                return 1
                ;;
        esac
        shift # past argument
        shift # past value
    done

    dbuild $repository
    dtag $repository $image_tag $environment
    dpush $repository $image_tag $environment
}

alias clean_images='docker image rm $(docker images -a -q) --force'

alias fmt='terraform fmt'

alias gpall='find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;'

# Reloads the bash_profile file
alias bashreload="source ~/.bash_profile && echo Bash config reloaded"

# Edit shortcuts for config files
alias bashprof="${EDITOR:-code} ~/.bash_profile && source ~/.bash_profile && echo Bash config edited and reloaded."

# Clear the screen
alias c="clear"
alias cl="clear;ls;pwd"

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
    # This is where you would place commands that require root user permissions if you had any!
    echo ""
fi

parse_git_branch()
{
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
