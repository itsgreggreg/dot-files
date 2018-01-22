# Creats symlinks for all the files in the dotfiles directory

Dir.chdir(File.expand_path('~/.dotfiles/dotfiles/'))
begin
  File.delete(File.expand_path('.gitkeep',Dir.pwd))
rescue
end
dotfiles = Dir.glob "\.[0-9,a-z,A-Z]*"
dotfiles.each do |dotfile|
  begin
    File.symlink(
      File.expand_path("~/.dotfiles/dotfiles/#{dotfile}"),
      File.expand_path("~/#{dotfile}")
    )
    puts "Linked #{dotfile}"
  rescue
    puts "Did not link dotfile #{dotfile}"
  end
end
