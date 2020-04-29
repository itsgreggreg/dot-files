# http://erlang.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](erl) %{
    set-option buffer filetype erlang
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=erlang %{
    require-module erlang
}

hook -group erlang-highlight global WinSetOption filetype=erlang %{
    add-highlighter window/erlang ref erlang
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/erlang }
}

provide-module erlang %[

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/erlang regions
add-highlighter shared/erlang/code default-region group
add-highlighter shared/erlang/code/         regex       \b[A-Z]\w*\b               0:variable
add-highlighter shared/erlang/double_string region '"'  (?<!\\)(\\\\)*"            regions
add-highlighter shared/erlang/code/         regex       ^[a-z]\w*\b                0:function
add-highlighter shared/erlang/code/         regex       \b(true|false|nil)\b       0:value
add-highlighter shared/erlang/              region '%'  '$'                        fill comment
add-highlighter shared/erlang/              region '^-' '[^(]*'                    fill attribute
add-highlighter shared/erlang/code/         regex       '\b\d+[\d_]*\b'            0:value
add-highlighter shared/erlang/code/         regex       \B[-+<>!@#$%^&*=:/\\|]+\B  0:operator


add-highlighter shared/erlang/double_string/ default-region fill string

evaluate-commands %sh{
#     # Grammar
    keywords="case|of|end|try|catch|when|_"
    printf %s "
        add-highlighter shared/erlang/code/ regex \b(${keywords})\b 0:keyword
    "
}

]

# Detection
# ‾‾‾‾‾‾‾‾‾

define-command -hidden erlang-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

