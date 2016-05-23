kerl_dir="$HOME/.kerl"
(mkdir $kerl_dir && cd $kerl_dir  && curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl)
chmod a+x $kerl_dir/kerl

exenv_dir="$HOME/.exenv"
git clone git://github.com/mururu/exenv.git $exenv_dir

