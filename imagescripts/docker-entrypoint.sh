#!/bin/bash
#
# A helper script for ENTRYPOINT.

exec stratisd -datadir=$STRATIS_DATA_DIR -rescan -detachdb
