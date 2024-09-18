#!/usr/bin/env bash

set -e

# x86 x64 armv6m armv7m armv7emsp armv7emdp xtensa xtensawin rv32imc
: ${ARCH=x64}

export PATH=.:$PATH

for APP in assemblyscript cpp rust tinygo zig virgil wat coremark; do
  echo "======================================"
  echo "    Building $APP.mpy ..."
  echo "======================================"
  echo
  make clean all ARCH=$ARCH APP=$APP 2>&1 >/dev/null

  if [[ $ARCH == @(x64|x86) ]]; then
    micropython-$ARCH -c "import $APP as app; app.setup(); app.loop(); app.loop()"
  else
    mpremote cp $APP.mpy : 2>&1 >/dev/null
    mpremote exec "import $APP as app; app.setup(); app.loop(); app.loop()" || true
  fi
  echo
done

GREEN="\033[0;32m"
NC="\033[0m"

echo "======================================"
echo -e "${GREEN}    ALL OK ${NC}"
echo "======================================"
