# cd also runs ls
function cd() {
    new_directory="$*";
    if [ $# -eq 0 ]; then 
        new_directory=${HOME};
    fi;
    builtin cd -- "${new_directory}" && ls
}

function ultradog() {
    if [ $# -eq 0 ]; then
        git add -u && git commit -m "do stuff" && git push
        return 0
    fi

    git add -u && git commit -m "$*" && git push
}

function dogshit() {
    if [ $# -eq 0 ]; then
        git commit -m "do stuff" && git push
        return 0
    fi

    git commit -m "$*" && git push
}


# beatufil ranger-cd
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        builtin cd -- "$(cat "$tempfile")"
    fi  
    rm -f -- "$tempfile"
}
