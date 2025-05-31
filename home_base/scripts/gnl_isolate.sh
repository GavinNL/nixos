#!/bin/bash

bwrap \
  --unshare-user \
  --unshare-pid \
  --unshare-ipc \
  --unshare-net \
  --dev-bind / / \
  --proc /proc \
  --dev /dev \
  --bind /run /run \
  --bind /sys /sys \
  --bind /etc/resolv.conf /etc/resolv.conf \
   --bind /tmp/.X11-unix/X0 /tmp/.X11-unix/X0 \
--setenv DISPLAY :0 \
--tmpfs /home/$USER \
--chdir /home/$USER \
  /bin/bash
exit

bwrap --share-net \
--unshare-pid \
--ro-bind /bin /bin \
--ro-bind /lib /lib \
--ro-bind /lib64 /lib64 \
--ro-bind /var /var \
--ro-bind /etc /etc \
--ro-bind /usr /usr \
--ro-bind /opt /opt \
--proc /proc \
--dev /dev \
--bind /tmp/.X11-unix/X0 /tmp/.X11-unix/X0 \
--setenv DISPLAY :0 \
--tmpfs /home/$USER \
--chdir /home/$USER \
bash
