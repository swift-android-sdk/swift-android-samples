#!/bin/sh -ex
for sample in */run.sh; do
    cd $(dirname ${sample})
    ./run.sh
    cd -
done
