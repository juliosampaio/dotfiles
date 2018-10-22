ZSH_CUSTOM_HOME="${HOME}/.oh-my-zsh/custom"
SPACESHIP_HOME="${ZSH_CUSTOM_HOME}/themes/spaceship-prompt"
if [ ! -d "${SPACESHIP_HOME}" ] ; then
  git clone https://github.com/denysdovhan/spaceship-prompt.git "${SPACESHIP_HOME}"
fi
ln -s "${ZSH_CUSTOM_HOME}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM_HOME}/themes/spaceship.zsh-theme"
