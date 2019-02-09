cd $HOME/.dotfiles
git clone https://github.com/gpakosz/.tmux.git
ln -s -f $HOME/.dotfiles/.tmux/.tmux.conf $HOME/
cp $HOME/.dotfiles/.tmux/.tmux.conf.local $HOME/
