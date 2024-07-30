if status is-interactive
    alias ssh="kitty +kitten ssh"
    # Machine
    alias psg='ps aux | grep'

    alias vi='nvim'
    alias vim='nvim'

    alias oc='kitty --single-instance -o allow_remote_control=yes --listen-on unix:/tmp/mykitty --start-as=maximized --session ~/.config/kitty/oc.conf &'
    alias dots='kitty --single-instance -o allow_remote_control=yes --listen-on unix:/tmp/mykitty --start-as=maximized --session ~/.config/kitty/dots.conf &'

    # Rails
    alias rsc='ruby script/rails c'
    alias b='bundle exec'
    alias bri="bundle list | tr -d '*(,)' | awk '{print $1, \"--version\", $2}' | xargs -n3 gem rdoc --ri --no-rdoc"

    # Navigation
    alias p='cd ~/Projects'
    alias x='exit'
    alias cp='cp -r'

    # Git
    alias g='git'
    alias gl="git log"
    alias gs='git st'
    alias gb='git branch -a'
    alias ga='git add'
    alias gci='git ci'
    alias gr='git rebase'
    alias gri='git rebase --interactive'
    alias gres='git reset --soft'
    alias gc='git commit -v'
    alias gca='git commit -v -a'
    alias gd='git diff'
    alias gl='git pull'
    alias gp='git push'
    alias gstag='git diff --cached --stat'
    alias gmt='git mergetool'
    alias gm='git co master'
    alias gap='git add --patch'
    alias gnb='git co -b'
    alias grh='git reset HEAD'
    alias gpr='git pull --rebase'
    alias gsc='git stash clear'
    alias grc='git rebase --continue'
    alias gsl='git show $(git stash list | cut -d":" -f 1)'
    alias gsp='git stash && git pull && git stash pop'

    # TODO: default to staging
    alias hrc='env TERM=xterm-256color heroku run rails console -a'

    export LC_CTYPE=en_US.UTF-8
    export EDITOR="nvim"
    export EVENT_NOKQUEUE=1
    export FD_SETSIZE=10000

    function dl_prod
        echo "dumping db"
        rm -rf db.dump
        set connStr (heroku config:get DATABASE_URL --app opencounter-v2)
        and echo " from: $connStr\n to: db.dump"
        and pg_dump -d $connStr --format=directory --exclude-table-data public.projects --exclude-table-data public.accela_records --exclude-table-data public.answer_attachments --exclude-table-data public.application_snapshots --exclude-table-data public.changesets --exclude-table-data public.line_items --exclude-table-data public.requests --exclude-table-data public.notes --exclude-table-data public.log_entries --exclude-table-data public.requirement_applications --exclude-table-data public.spec_results --exclude-table-data public.transactions --create --jobs 5 --file ./db.dump

        # check for active connections
        set activeConns (psql opencounter_dev -t -c "SELECT sum(numbackends) FROM pg_stat_database")
        if math $activeConns \> 1
            echo "database has active connections and can't be restored to"
            return
        end

        echo "drop/create db."
        bin/rake db:drop db:create
        echo "restoring dump."
        pg_restore -Fd -j 8 -h localhost -d opencounter_dev db.dump 2>db_restore.log
        echo "running migrations."
        set RAILS_ENV development
        bin/rake db:migrate
    end

    function dshell
        set container (docker ps --format '{{.Names}}' | fzf)
        if test -n "$container"
            docker exec -it $container /bin/bash
        end
    end

    function drun
        set image (docker images --format '{{.Repository}}:{{.Tag}}' | fzf)
        if test -n "$image"
            docker run -it $image /bin/bash
        end
    end
end

set -g fish_greeting
set -g fish_key_bindings fish_vi_key_bindings
fish_add_path "./node_modules"
fish_add_path /usr/local/sbin
fish_add_path /usr/local/share/npm/bin/
fish_add_path /opt/homebrew/bin
# export PATH=./node_modules/:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/share/npm/bin/:$PATH
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
# export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
source ~/.asdf/asdf.fish

# pyenv init - | source

fish_add_path "./bin"
direnv hook fish | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/joshua/google-cloud-sdk/path.fish.inc' ]
    . '/Users/joshua/google-cloud-sdk/path.fish.inc'
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/joshua/miniconda3/bin/conda
    eval /Users/joshua/miniconda3/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<

# Created by `pipx` on 2023-10-20 20:31:41
set -U PATH $PATH /Users/joshua/.local/bin
