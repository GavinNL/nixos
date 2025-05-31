#!/bin/env bash
rclone sync -v --progress --transfers 32 /home/gavin/Documents pcloud:/HOME/Documents
rclone sync -v --progress --transfers 32 /home/gavin/Pictures  pcloud:/HOME/Pictures
rclone sync -v --progress --transfers 32 /home/gavin/Videos    pcloud:/HOME/Videos
