# export the current folder as a binary path
alias xp='export PATH=$PWD:$PATH'

# export the current folder as LD_LIBRARY_PATH
alias xlp='export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH'

# export the current folder as a python path
alias xpp='export PYTHONPATH=$PWD:$PYTHONPATH'


function gnl_swap() {

   if [[ ! -e $1 ]]; then
      echo $1 does not exist
      exit 1
   fi

   if [[ ! -e $2 ]]; then
      echo $2 does not exist
      exit 1
   fi

   mv $1 $1.old.swap
   mv $2 $1 
   mv $1.old.swap $2
}
