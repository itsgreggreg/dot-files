#
# Taken from:
# https://github.com/TeddyDD/kakoune-edit-or-dir
# If you try to edit a dir, it opens a little browser for that dir
# 
define-command edit-or-dir -file-completion -params .. %{
    evaluate-commands %sh{
        echo "try %{ delete-buffer! *dir* }"
        arg="$1"
        pwd=$(pwd)

        case "$arg" in
            '')  dir="$pwd" ;;
            ~*)  dir="$HOME${arg#~*}" ;;
            /*)  dir="$arg" ;;
            ..*) dir="$pwd/$arg"
                 prev="/${pwd##*/}<ret>;" ;;
            *)   dir="$pwd/$arg" ;;
        esac

        if [ -d "$dir" ]; then
            echo "change-directory %{$dir}"
            echo "edit-or-dir-display-dir %{$arg}"
            echo "try %{ execute-keys %{$prev}}"
        else
            echo "edit %{$*}"
        fi
    }
}

declare-option -hidden str edit_or_dir_hidden ''

define-command -hidden -params 1 edit-or-dir-display-dir %{
    edit -scratch *dir*
    set-option window filetype 'file_select'
    evaluate-commands %sh{
        keys="ls<space>$kak_opt_edit_or_dir_hidden<space>-p<space><ret>xdgg"
        if [ "$(pwd)" = '/' ]; then
            keys="!${keys}"
        else
            keys="!echo<space>../<space>&&<space> $keys"
        fi
        echo "execute-keys '$keys'"
    }
    # group directories together
    try %{ execute-keys %{ %<a-s><a-k>/$<ret>dgg<a-P>;gg } }
    # clean up empty lines
    try %{ execute-keys -draft %{ %<a-s><a-k>^$<ret>d } }
}

define-command -hidden edit-or-dir-forward %{
    execute-keys '<a-s>'
    evaluate-commands -draft -itersel %{
        execute-keys ';x_'
        evaluate-commands -draft %{ try %{ edit %reg{.} } }
    }
    execute-keys '<space>;x_'
    edit-or-dir %reg{.}
}

define-command -hidden edit-or-dir-back %{
    edit-or-dir ..
}

hook global WinSetOption filetype=file_select %{
    map window normal <ret> ':<space>edit-or-dir-forward<ret>'
    map window normal <backspace> ':<space>edit-or-dir-back<ret>'
    map window normal <esc> ':<space>db<ret>'
    map window normal <a-h> ':<space>edit-or-dir-toggle-hidden<ret>'
    add-highlighter window/dir regex '^.+/$' 0:list
}

define-command -hidden edit-or-dir-toggle-hidden %{
    evaluate-commands %sh{
        if [ -z $kak_opt_edit_or_dir_hidden ]; then
            echo "set-option global edit_or_dir_hidden '-A'"
        else
            echo "set-option global edit_or_dir_hidden ''"
        fi
        echo "edit-or-dir"
    }
}

