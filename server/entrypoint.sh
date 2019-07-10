#!/usr/bin/env bash
set -ex

if [ ! -f $GRIN_PATH/grin-server.toml ]; then
    if [ ! -d $GRIN_PATH ]; then
        # Create the given directory if it doesn't exist yet
        mkdir $GRIN_PATH
    fi

    # Publish the Grin server configuration file
    (cd $GRIN_PATH; grin $GRIN_NET_ARG server config)
fi

# Don't run the ncurses TUI
sed -i -e 's/run_tui = true/run_tui = false/' $GRIN_PATH/grin-server.toml

# Ensure the API is reachable from a remote connection
sed -i -e 's/api_http_addr = "127.0.0.1:13413"/api_http_addr = "0.0.0.0:13413"/' $GRIN_PATH/grin-server.toml

# Overwrite the API key
echo $GRIN_API_SECRET > $GRIN_PATH/.api_secret

# Run a Grin node
grin $GRIN_NET_ARG
