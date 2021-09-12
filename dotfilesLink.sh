
#!/bin/sh

ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/colors ~/.vim/colors
ln -sf ~/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

mkdir -p ~/.config/nvim
ls -sf ~/dotfiles/nvim ~/.config/nvim

mkdir ~/.vim/bundle

