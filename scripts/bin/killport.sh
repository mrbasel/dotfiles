#!/bin/bash

if [[ -n "$1" ]]; then
    kill $(lsof -t -i:$1)
else
    echo "killport: missing port operand"
fi
