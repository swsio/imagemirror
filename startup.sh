#!/usr/bin/env bash
set -Eeo pipefail

if [ $debug == "true" ]; then
    echo "Debug enabled"
    cat /mirror/config/run | parallel -j $THREADS -u
else
    echo "Debug disabled"
    cat /mirror/config/run | parallel -j $THREADS
fi