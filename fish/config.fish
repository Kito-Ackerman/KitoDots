##vairabili##
set -U fish_user_paths $fish_user_paths $HOME/.local/bin/
set fish greeting
set TERM "xterm-256color"
set EDITOR "nvim"
set VISUAL "emacsclient -t -a emacs"

##prompt##
function fish_prompt
    set -l last_status $status
    echo -n '| '

    ##User
    set_color cyan
    echo -n $USER

    ##Chiocciola
    set_color yellow
    echo -n '@'

    ##Host
    set_color red
    echo -n (prompt_hostname)
    set_color normal
    echo -n ': '

    ##Cartelle
    set_color yellow
    echo -n (prompt_pwd)

    ##Git
    printf '%s ' (__fish_git_prompt)
    set_color normal

    ##$
    set_color normal
    echo -n ' > '
    set_color normal
end

##aliases##

###Comuni
alias cls "clear"
alias lla="ls -lha"
alias mkdir="mkdir -pv"
alias userlist="cut -d: -f /etc/passwd"
alias fhere="find . -name "
alias free="free -mt"
alias ps="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias wget="wget -c"
alias histg="history | grep"
alias myip="curl http://ipecho.net/plain; echo"
alias folders='find . -maxdepth  -type d -print0 | xargs -0 du -sk | sort -rn'
alias grep='grep --color=auto'
alias df="df -ahiT --total"
alias ls="ls -CF --color=auto"
alias ll="ls -lisa --color=auto"
alias lsl="ls -lhFA | less"

###Cd
alias D="cd /mnt/103C02053C01E696"
alias E="cd /mnt/8E02C7C902C7B50D"
alias programmi="cd /mnt/103C02053C01E696/programmi"
alias home="cd ~"
alias ..="cd .."
alias cd..="cd .."

alias "ls"="exa"
alias "ll"="exa -lh"
alias "lla"="exa -lha"

###Vi
alias visudo="sudo nvim"
alias vi="nvim"
alias vim="nvim"

###Emacs
alias em="emacsclient -t -a ''"
alias emacs="emacsclient -c -a emacs"
alias doom="~/.emacs.d/bin/doom"

### file da modificare velocemente
alias fishconf "emacs ~/.config/fish/config.fish.org"
alias reload="source ~/.config/fish/config.fish"
alias bashconf="emacs ~/.bashrc.org"
alias zshconf="emacs ~/.zshrc"
alias zshpromptconf="emacs ~/.p0k.zsh"
alias awesomeconf="emacs ~/.config/awesome/rc.lua.org"
alias prompt_config="emacs ~/.oh-my-zsh/themes/bira.zsh-theme"

###YUI
alias Yui="cd /mnt/103C02053C01E696/programmi/python/Yui/UnixVersion;python3 yui-core.py"
alias yui="Yui"

###Pacman
alias cls="clear"
alias update="sudo pacman -Syy"
alias upgrade="yay"

###Ntfsfixall
alias ntfsfixall="sudo umount /dev/sdb;sudo umount /dev/sdb2;sudo ntfsfix /dev/sdb1 >/dev/null; sudo ntfsfix /dev/sdb2 >/dev/null;sudo mount -a >/dev/null"

alias plex-start="cd /usr/lib/plexmediaserver/ && ./Plex\ Media\ Server"

##Funzioni##
###Ex
function ex -d "Expand or extract bundled & compressed files"
    for file in $argv
        if test -f $file
            echo -s "Extracting: " (set_color --bold blue) $file (set_color normal)
            switch $file
                case *.tar
                    tar -xf $file
                case *.tar.xz *.txz
                    # Use pixz for parallel extraction, if available
                    set os (uname)
                    if [ $os = "Kito" ]
                        command -s pixz gtar >/dev/null
                        and gtar -Ipixz -xf $file
                        or tar -Jxf $file
                    else
                        command -s pixz >/dev/null
                        and tar -Ipixz -xf $file
                        or tar -Jxf $file
                    end
                case *.tar.bz2 *.tbz *.tbz2
                    tar -jxf $file
                case *.tar.gz *.tgz
                    tar -zxf $file
                case *.xz
                    command -s pixz >/dev/null
                    and pixz -d $file
                    or unxz $file
                case *.bz2
                    bunzip2 $file
                case *.gz
                    gunzip $file
                case *.rar
                    unrar x $file
                case *.zip
                    unzip -uo $file -d (basename $file .zip)
                case *.pax
                    pax -r < $file
                case '*'
                    echo "Extension not recognized, cannot extract $file"
            end
        else
            echo "$file is not a valid file"
        end
    end
end

###compress
function compress -d "Compress a file or directory via xz, with optional destination"
    # Target is a file
    if test -f $argv[1]
        set file $argv[1]
        # If no destination is provided, compress in-place
        if test (count $argv) = 1
            set destination $file.xz
        else
            set destination $argv[2]
        end
        echo -s "Compressing file: " (set_color --bold blue) $file (set_color normal)
        command -s pixz >/dev/null
        and pixz $file $destination
        or xz $file $destination
    end

    # Target is a directory
    if test -d $argv[1]
        set directory $argv[1]
        # If no destination is provided, compress in-place
        if test (count $argv) = 1
            set destination $directory.txz
        else
            set destination $argv[2]
        end
        echo -s "Compressing directory: " (set_color --bold blue) $directory (set_color normal)
        set os (uname)
        switch $os
            case Darwin
                command -s gtar pixz >/dev/null
                and gtar -Ipixz -cf $destination $directory
                or tar -Jcf $destination $directory
            case '*'
                command -s pixz >/dev/null
                and tar -Ipixz -cf $destination $directory
                or tar -Jcf $destination $directory
        end
    end
end

# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end
# The bindings for !! and !$
if [ $fish_key_bindings = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

#vterm
if [ "$INSIDE_EMACS" = 'vterm' ]
    function clear
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
    end
end

##colorscript
/usr/bin/colorscript -r
