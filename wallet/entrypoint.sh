#!/usr/bin/env bash
set -ex

if [ ! -f $GRIN_PATH/grin-wallet.toml ]; then
    # Create the wallet
    expect -c 'spawn grin-wallet '$GRIN_NET_ARG' init; expect "Password:"; send '$GRIN_WALLET_PASSWORD'\r; expect "Confirm Password:"; send '$GRIN_WALLET_PASSWORD'\r; expect eof'
fi

if [ $GRIN_INCLUDE_OWNER_API = true ]; then
    # Include the foreign API endpoints on the same port
    sed -i -e 's/owner_api_include_foreign = false/owner_api_include_foreign = true/' $GRIN_PATH/grin-wallet.toml
else
    # Don't include the foreign API endpoints on the same port
    sed -i -e 's/owner_api_include_foreign = true/owner_api_include_foreign = false/' $GRIN_PATH/grin-wallet.toml
fi

# # Ensure we can receive Grin (similar to specifying the "-e" option to "grin-wallet" command)
# sed -i -e 's/api_listen_interface = "127.0.0.1"/api_listen_interface = "0.0.0.0"/' $GRIN_PATH/grin-wallet.toml

# Overwrite the API key
echo $GRIN_API_SECRET > $GRIN_PATH/.api_secret

if [ ! -d $GRIN_PATH/owner ]; then
    # Create the folder for the owner API wallet listener
    mkdir $GRIN_PATH/owner
fi

# Run Supervisor (starts a wallet listener and owner API listener)
/usr/bin/supervisord
