#!/usr/bin/env bash
set -Eeo pipefail

### Do things PARALLEL
cat /mirror/config/run | parallel -j $THREADS