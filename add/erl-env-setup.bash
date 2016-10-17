kerl_dir="$HOME/.kerl"

if [ ! -d $kerl_dir ]; then
  (mkdir $kerl_dir && cd $kerl_dir  && curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl)
  chmod a+x $kerl_dir/kerl
  # install reminders for erlang on UBUNTU
  # sudo apt-get install build-essential libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev
  # sudo apt-get install libwxbase3.0-dev libwxgtk3.0-dev libqt4-opengl-dev
  #
  # ---> http://docs.basho.com/riak/1.3.0/tutorials/installation/Installing-Erlang/
fi

if [ ! -d $kerl_dir ]; then
  exenv_dir="$HOME/.exenv"
  git clone git://github.com/mururu/exenv.git $exenv_dir
fi

