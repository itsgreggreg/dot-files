
# Elm
hook global BufCreate .*[.]elm %{
  set buffer formatcmd "elm-format --stdin --elm-version=0.19"
}
hook global BufWritePre .+\.elm %{ format }

# CSS, SCSS, JS, MD
hook global BufCreate .*[.](css|scss|js|md|json|html) %{
  set buffer formatcmd "prettier --stdin --stdin-filepath=$kak_buffile"
}
hook global BufWritePre .+\.(css|scss|js|md|json|html) %{ format }

# Haskell
hook global BufCreate .*[.]hs %{
  set buffer formatcmd "hindent"
}
hook global BufWritePre .+\.hs %{ format }

# Elixir
hook global BufCreate .*[.](ex|exs) %{
  set buffer formatcmd "mix format -"
}
hook global BufWritePre .+\.(ex|exs) %{ format }

# rust
hook global BufCreate .*[.](rs) %{
  set buffer formatcmd "rustfmt"
}
hook global BufWritePre .+\.(rs) %{ format }


# dart
hook global BufCreate .*[.](dart) %{
  set buffer formatcmd "dartfmt"
}
hook global BufWritePre .+\.(dart) %{ format }

# Howdy
hook global BufCreate .*[.]howdy %{
  set buffer formatcmd "~/Trash/howdy/target/debug/howdy format --stdin"
}
hook global BufWritePre .+\.howdy %{ format }

