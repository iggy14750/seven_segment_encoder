

Run GHDL through Docker
-----------------------

Step 1: Build the container.

    ./scripts/build-container.sh

Step 2: Create an alias for the GHDL command using this container.

    . scripts/ghdl-docker.sh

After this, any use of the command "ghdl" at the command-line will use the implementation hosted in the docker container.

