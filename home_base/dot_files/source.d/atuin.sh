# export the current folder as a binary path
if [[ $(which atuin) = "" ]]; then
    
VERSION=18.6.1

mkdir $HOME/.local/bin

rm -rf /tmp/atuin-dwn
mkdir /tmp/atuin-dwn
cd /tmp/atuin-dwn

wget https://github.com/atuinsh/atuin/releases/download/v${VERSION}/atuin-x86_64-unknown-linux-musl.tar.gz
tar -xvf atuin-x86_64-unknown-linux-musl.tar.gz

mkdir -p ${HOME}/.local/bin
cp atuin-x86_64-unknown-linux-musl/atuin $HOME/.local/bin

cd -
rm -rf /tmp/atuin-dwn

rm -rf $HOME/.bash-preexec.sh $HOME/.atuin.sh

curl -s https://raw.githubusercontent.com/rcaloras/bash-preexec/refs/tags/0.5.0/bash-preexec.sh > $HOME/.bash-preexec.sh
$HOME/.local/bin/atuin init bash --disable-up-arrow > $HOME/.atuin.sh

fi


if [[ ! "${CONTAINER_ID}" == "" ]]; then

    if [[ -e $HOME/.bash-preexec.sh ]]; then
        source $HOME/.bash-preexec.sh
    fi

    if [[ -e $HOME/.atuin.sh ]]; then
        source $HOME/.atuin.sh
    fi

fi


