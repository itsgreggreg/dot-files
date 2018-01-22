# Create a subgroup called "todo"
addhl -group / group todo

# Make the subgroup highlight certain keywords
addhl -group /todo regex TODO 0:default+rb

# Assign the "gdt" highlighter to each language's comments highlighter
%sh{
    LANGS=(
        c
        cabal
        coffee
        cpp
        css
        cucumber
        dlang
        erlang
        elixir
        elm
        fish
        golang
        haml
        haskell
        html
        java
        javascript
        julia
        kakrc
        kickstart
        lisp
        objc
        python
        ragel
        ruby
        rust
        sass
        scala
        sh
        yaml
    )
    for lang in "${LANGS[@]}"; do
        echo "try %{ addhl -group /${lang}/comment ref todo}"
    done
}
