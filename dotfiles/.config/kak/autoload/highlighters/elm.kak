# http://elm-lang.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](elm) %{
    set buffer filetype elm
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

addhl -group / regions -default code elm \
    string   '"'     (?<!\\)(\\\\)*"      '' \
    comment  (--) $                       '' \
    comment \{-   -\}                    \{- \
    macro   ^\h*?\K# (?<!\\)\n            ''

addhl -group /elm/string  fill string
addhl -group /elm/comment fill comment
addhl -group /elm/macro   fill meta

addhl -group /elm/code regex \b(import)\b 0:meta
addhl -group /elm/code regex \b(True|False)\b 0:value
addhl -group /elm/code regex \b(as|case|class|data|default|deriving|do|exposing|else|hiding|if|in|infix|infixl|infixr|instance|let|module|newtype|of|qualified|then|type|where)\b 0:keyword
addhl -group /elm/code regex \b(Int|Integer|Char|Bool|Float|Double|IO|Void|Addr|Array|String)\b 0:type

# Commands
# ‾‾‾‾‾‾‾‾

# http://en.wikibooks.org/wiki/Haskell/Indentation

def -hidden _elm_filter_around_selections %{
    # remove trailing white spaces
    try %{ exec -draft -itersel <a-x> s \h+$ <ret> d }
}

def -hidden _elm_indent_on_new_line %{
    eval -draft -itersel %{
        # preserve previous line indent
        try %{ exec -draft <space> K <a-&> }
        # align to first clause
        try %{ exec -draft <space> k x X s ^\h*(if|then|else)?\h*(([\w']+\h+)+=)?\h*(case\h+[\w']+\h+of|do|let|where)\h+\K.* <ret> s \`|.\' <ret> & }
        # filter previous line
        try %{ exec -draft k : _elm_filter_around_selections <ret> }
        # copy -- comments prefix and following white spaces
        try %{ exec -draft k x s ^\h*\K--\h* <ret> y j p }
        # indent after lines beginning with condition or ending with expression or =(
        try %{ exec -draft <space> k x <a-k> ^\h*(if)|(case\h+[\w']+\h+of|do|let|where|[=(])$ <ret> j <a-gt> }
    }
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group elm-highlight global WinSetOption filetype=elm %{ addhl ref elm }

hook global WinSetOption filetype=elm %{
    hook window InsertEnd  .* -group elm-hooks  _elm_filter_around_selections
    hook window InsertChar \n -group elm-indent _elm_indent_on_new_line
}

hook -group elm-highlight global WinSetOption filetype=(?!elm).* %{ rmhl elm }

hook global WinSetOption filetype=(?!elm).* %{
    rmhooks window elm-indent
    rmhooks window elm-hooks
}

# Comment hook
hook global BufSetOption filetype=elm %{
    set buffer comment_line_chars '-- '
    set buffer comment_selection_chars '{- : -}'
}
