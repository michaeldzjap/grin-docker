#!/usr/bin/env bash
set -ex

if [ $GRIN_NET = 'floonet' ]; then
    net='--floonet'
    dir='floo'
else
    net=''
    dir='main'
fi

path=/root/.grin/$dir

if [ ! -f $path/grin-server.toml ]; then
    if [ ! -d $path ]; then
        # Create the given directory if it doesn't exist yet
        mkdir $path
    fi

    # Publish the Grin server configuration file
    (cd $path; grin $net server config)

    # Don't run the ncurses TUI
    sed -i -e 's/run_tui = true/run_tui = false/' $path/grin-server.toml

    # Ensure the API is reachable from a remote connection
    sed -i -e 's/api_http_addr = "127.0.0.1:13413"/api_http_addr = "0.0.0.0:13413"/' $path/grin-server.toml
fi

# Overwrite the API key
echo $GRIN_API_SECRET > $path/.api_secret

# Run a Grin node
grin $net
