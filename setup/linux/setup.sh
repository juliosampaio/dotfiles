echo "Starting linux setup"
SETUP_HOME="${HOME}/.dotfiles/setup/linux"
#----------------------------------------
#                 ZSH
#---------------------------------------
echo "Installing oh-my-zsh"
zsh --version 2>&1 >/dev/null
ZSH_IS_AVAILABLE=$?
if [ $ZSH_IS_AVAILABLE -eq 0 ]; then
  echo "ZSH already installed, skiping..."
else
  $SETUP_HOME/zsh.sh
fi
#----------------------------------------
#              SPACESHIP
#---------------------------------------
echo "Installing spaceship-prompt"
$SETUP_HOME/spaceship.sh
