#!/bin/bash

# set -xe
set -e

echo "tar-node-action start"
ssh_host=$1
ssh_host_project_path=$2

if [ -z "$ssh_host" ]; then
  echo "not set ssh_host, exit"
  exit 0
fi

if [ -z "$ssh_host_project_path" ]; then
  echo "not set ssh_host_project_path, exit"
  exit 0
fi

echo "ssh_host: ${ssh_host}"

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


# deploy to ssh_host
# exec command at remote machine

# mkdir -p
echo "remote: mkdir -p ${ssh_host_project_path}/releases"
ssh ${ssh_host} mkdir -p ${ssh_host_project_path}/releases
# scp
echo "try scp ${target_tar_file}"
scp ${target_tar_file} ${ssh_host}:${ssh_host_project_path}/releases
# untar
echo "remote: try untar"
ssh ${ssh_host} tar -zx -f ${ssh_host_project_path}/releases/${target_tar_file} -C ${ssh_host_project_path}/releases
# change soft link
echo "remote: change soft link"
ssh ${ssh_host} ln -sfT ${ssh_host_project_path}/releases/${target_dir} ${ssh_host_project_path}/current
# delete tar
echo "remote: delete ${target_tar_file}"
ssh ${ssh_host} rm ${ssh_host_project_path}/releases/${target_tar_file}
# todo: delete old release


# delete local files
echo "local: delete ${target_tar_file}"
rm ${target_tar_file}
