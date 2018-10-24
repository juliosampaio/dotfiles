echo "Linking .config files"
CONFIG_HOME=$HOME/.dotfiles/config

for file in $CONFIG_HOME/.[^.]*;
do
    if [[ -f $file ]]; then
        ln -sf $file $HOME/$(basename $file)
    fi
done
echo "Linking done"