#!/bin/sh

voxtype setup model
sudo voxtype setup gpu --enable
systemctl --user restart voxtype

