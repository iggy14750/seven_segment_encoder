#!/bin/bash

## TODO: cd into the ghdl dir

_dir="$(dirname $(realpath $(dirname $0)))"
echo $dir
cd ghdl
_sources=( \
	$_dir/hdl/hello.vhd \
	$_dir/sim/seven_segment_tb.vhd \
)

ghdl -a --std=08 -frelaxed -fsynopsys -Wno-hide -Wno-shared ${_sources[@]}
cd -

