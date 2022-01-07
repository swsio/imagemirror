#!/usr/bin/env bash

if [ $debug == "true" ]; then
    echo "Debug enabled"
else
    echo "Debug disabled"
    set -Eeo pipefail
fi

### Do things PARALLEL
cat /mirror/config/run | parallel -j $THREADS