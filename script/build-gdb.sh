#!/usr/bin/env sh

# Motivation: build gdb 11 from source because of this issue: https://github.com/Gallopsled/pwntools/issues/1783

# Optional: remove existing gdb
#sudo apt remove gdb gdbserver

# Get latest source from https://ftp.gnu.org/gnu/gdb/
wget https://ftp.gnu.org/gnu/gdb/gdb-11.1.tar.xz

tar xf gdb-11.1.tar.xz

# Install necessary build tools
sudo apt install -y build-essential texinfo bison flex

cd gdb-11.1

# Configure with python3 support
./configure --with-python=/usr/bin/python3

# Build (this takes a while)
make -j8

# Install binary
sudo make install
