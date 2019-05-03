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
wallet_path=$path/wallet_data

if [ ! -f $path/grin-wallet.toml ]; then
    # Create the wallet
    expect -c 'spawn grin-wallet '$net' init; expect "Password:"; send '$GRIN_WALLET_PASSWORD'\r; expect "Confirm Password:"; send '$GRIN_WALLET_PASSWORD'\r; expect eof'
fi

if [ $GRIN_INCLUDE_OWNER_API = true ]; then
    # Include the foreign API endpoints on the same port
    sed -i -e 's/owner_api_include_foreign = false/owner_api_include_foreign = true/' $path/grin-wallet.toml
else
    # Don't include the foreign API endpoints on the same port
    sed -i -e 's/owner_api_include_foreign = true/owner_api_include_foreign = false/' $path/grin-wallet.toml
fi

# # Ensure we can receive Grin (similar to specifying the "-e" option to "grin-wallet" command)
# sed -i -e 's/api_listen_interface = "127.0.0.1"/api_listen_interface = "0.0.0.0"/' $path/grin-wallet.toml

# Overwrite the API key
echo $GRIN_API_SECRET > $path/.api_secret

if [ ! -d $path/owner ]; then
    mkdir $path/owner
fi

# Start the Grin wallet listener, including owner API
(cd $path/owner; grin-wallet $net -e -r http://$GRIN_SERVER_HOST:$GRIN_SERVER_PORT -p $GRIN_WALLET_PASSWORD owner_api)
