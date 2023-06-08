#!/bin/bash

docker run \
	-v $(pwd):/app \
	learn-uvvm

#--mount 'type=volume,src=.dst=.' \
