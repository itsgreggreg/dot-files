# http://gleam.run
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](gleam) %{
    set-option buffer filetype gleam
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=gleam %[
    require-module gleam
    hook window ModeChange pop:insert:.* -group gleam-trim-indent gleam-trim-indent
    hook window InsertChar \n -group gleam-indent gleam-indent-on-new-line
    hook window InsertChar \{ -group gleam-indent gleam-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group gleam-indent gleam-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window gleam-.+ }
]

hook -group gleam-highlight global WinSetOption filetype=gleam %{
    add-highlighter window/gleam ref gleam
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/gleam }
}

provide-module gleam %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/gleam regions
add-highlighter shared/gleam/code default-region group
add-highlighter shared/gleam/string           region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
add-highlighter shared/gleam/documentation    region "///" "$"                            fill documentation
add-highlighter shared/gleam/line_comment     region "//" "$"                                fill comment

add-highlighter shared/gleam/code/byte_literal         regex "'\\\\?.'" 0:value
add-highlighter shared/gleam/code/long_quoted          regex "('\w+)[^']" 1:meta
add-highlighter shared/gleam/code/field_or_parameter   regex (_?\w+)(?::)(?!:) 1:variable
add-highlighter shared/gleam/code/namespace            regex [a-zA-Z](\w+)?(\h+)?(?=::) 0:module
add-highlighter shared/gleam/code/field                regex ((?<!\.\.)(?<=\.))_?[a-zA-Z]\w*\b 0:meta
add-highlighter shared/gleam/code/function_call        regex _?[a-zA-Z]\w*\s*(?=\() 0:function
add-highlighter shared/gleam/code/user_defined_type    regex \b[A-Z]\w*\b 0:type
add-highlighter shared/gleam/code/function_declaration regex (?:fn\h+)(_?\w+)(?:<[^>]+?>)?\( 1:function
add-highlighter shared/gleam/code/variable_declaration regex (?:let\h+(?:mut\h+)?)(_?\w+) 1:variable
add-highlighter shared/gleam/code/macro                regex \b[A-z0-9_]+! 0:meta
# the number literals syntax is defined here:
# https://doc.gleam-lang.org/reference.html#number-literals
add-highlighter shared/gleam/code/values regex \b(?:self|True|False|[0-9][_0-9]*(?:\.[0-9][_0-9]*|(?:\.[0-9][_0-9]*)?E[\+\-][_0-9]+)(?:f(?:32|64))?|(?:0x[_0-9a-fA-F]+|0o[_0-7]+|0b[_01]+|[0-9][_0-9]*)(?:(?:i|u|f)(?:8|16|32|64|128|size))?)\b 0:value
add-highlighter shared/gleam/code/attributes regex \b(?:trait|struct|enum|type|mut|ref|static|const)\b 0:attribute
# the language keywords are defined here, but many of them are reserved and unused yet:
# https://doc.gleam-lang.org/grammar.html#keywords
add-highlighter shared/gleam/code/keywords             regex \b(?:let|import|fn|case|external|if|else|loop|for|while|break|continue|move|box|where|impl|dyn|pub|unsafe|async|await|mod|crate|use|extern)\b 0:keyword
add-highlighter shared/gleam/code/builtin_types        regex \b(?:u8|u16|u32|u64|u128|usize|i8|i16|i32|i64|i128|isize|f32|f64|bool|char|str|Self)\b 0:type
add-highlighter shared/gleam/code/return               regex \breturn\b 0:meta

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden gleam-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden gleam-indent-on-new-line %~
    evaluate-commands -draft -itersel %<
        # copy // comments prefix and following white spaces
        try %{
            execute-keys -draft k <a-x> s ^\h*\K//[!/]?\h* <ret> y gh j P
        } catch %|
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k <a-x> <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+ and move first parameter to own line
            try %< execute-keys -draft [c[({],[)}] <ret> <a-k> \A[({][^\n]+\n[^\n]*\n?\z <ret> L i<ret><esc> <gt> <a-S> <a-&> >
        |
        # filter previous line
        try %{ execute-keys -draft k : gleam-trim-indent <ret> }
    >
~

define-command -hidden gleam-indent-on-opening-curly-brace %[
    evaluate-commands -draft -itersel %_
        # align indent with opening paren when { is entered on a new line after the closing paren
        try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
    _
]

define-command -hidden gleam-indent-on-closing %[
    evaluate-commands -draft -itersel %_
        # align to opening curly brace or paren when alone on a line
        try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
    _
]

§

