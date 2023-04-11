#!/bin/bash
# install ncurses
set -e

ROOTDIR=${ZZROOT:-$HOME/app}
NAME="ncurses"
TYPE=".tar.gz"
FILE="$NAME$TYPE"
DOWNLOADURL="https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
echo $NAME will be installed in "$ROOTDIR"

mkdir -p "$ROOTDIR/downloads"
cd "$ROOTDIR"

if [ -f "downloads/$FILE" ]; then
    echo "downloads/$FILE exist"
else
    echo "$FILE does not exist, downloading from $DOWNLOADURL"
    wget --no-check-certificate $DOWNLOADURL -O $FILE
    mv $FILE downloads/
fi

mkdir -p src/$NAME
tar xf downloads/$FILE -C src/$NAME --strip-components 1

cd src/$NAME

./configure --prefix="$ROOTDIR" --with-shared --enable-pc-files --enable-widec --with-pkg-config-libdir="$ROOTDIR"/lib/pkgconfig
make -j"$(nproc)" && make install

echo $NAME installed on "$ROOTDIR"
echo You may need
echo export TERMINFO="$ROOTDIR/share/terminfo"
