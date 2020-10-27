#!/bin/bash

# set -xe

echo "tar-node-action start"

code_dir=$(pwd)
echo "code_dir: $code_dir"

cd ..

target_dir=$(date '+%Y%m%d%H%M%S')
echo "target_dir: $target_dir"

target_dir_full="$(pwd)/${target_dir}"
echo "target_dir_full: $target_dir_full"

cp -Rf $code_dir $target_dir
echo "copied"

target_tar_file="${target_dir}.tar.gz"
echo "target_tar_file: $target_tar_file"

tar -zc -f $target_tar_file $target_dir
echo "tared to $(pwd)/${target_tar_file}"
ls -lh ${target_tar_file}

rm -rf $target_dir
echo "removed tmp dir ${target_dir_full}"
