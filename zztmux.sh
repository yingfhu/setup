#!/bin/bash
# install tmux
set -e

ROOTDIR=${ZZROOT:-$HOME/app}
NAME="tmux"
TYPE=".tar.gz"
FILE="$NAME$TYPE"
DOWNLOADURL="https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz"
echo $NAME will be installed in "$ROOTDIR"
echo "hey, install libevent first"

mkdir -p "$ROOTDIR/downloads"
cd "$ROOTDIR"

if [ -f "downloads/$FILE" ]; then
    echo "downloads/$FILE exist"
else
    echo "$FILE does not exist, downloading from $DOWNLOADURL"
    wget $DOWNLOADURL -O $FILE
    mv $FILE downloads/
fi

mkdir -p src/$NAME
tar xf downloads/$FILE -C src/$NAME --strip-components 1

cd src/$NAME

export CFLAGS="-I$ROOTDIR/include -I$ROOTDIR/include/ncursesw"
export CPPFLAGS="-I$ROOTDIR/include -I$ROOTDIR/include/ncursesw"
export LDFLAGS="-L$ROOTDIR/lib"

./configure --prefix="$ROOTDIR" PKG_CONFIG_PATH=${ROOTDIR}/lib/pkgconfig 
make -j"$(nproc)" && make install

echo $NAME installed on "$ROOTDIR"
