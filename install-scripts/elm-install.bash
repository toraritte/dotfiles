if hash elm 2>/dev/null
then
  echo "Elm is already installed"
else
  sudo npm install -g elm
  sudo npm install -g elm-test
  sudo npm install -g elm-oracle
  echo "Don't forget to install elm-format"
fi
