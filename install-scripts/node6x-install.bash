# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if hash nodejs 2>/dev/null
then
  echo "node.js is already installed"
else
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash \
  && sudo apt install -y nodejs
fi
