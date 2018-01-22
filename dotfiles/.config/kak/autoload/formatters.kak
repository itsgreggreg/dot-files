
# Elm
hook global BufCreate .*[.]elm %{
  set buffer formatcmd "elm-format --stdin"
}
hook global BufWritePre .+\.elm %{ format }

# CSS, SCSS, JS, MD
hook global BufCreate .*[.](css|scss|js|md) %{
  set buffer formatcmd "prettier --stdin --stdin-filepath=$kak_buffile"
}
hook global BufWritePre .+\.(css|scss|js|md) %{ format }


# Haskell
hook global BufCreate .*[.]hs %{
  set buffer formatcmd "hindent"
}
hook global BufWritePre .+\.hs %{ format }
