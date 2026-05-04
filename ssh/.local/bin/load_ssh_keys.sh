#!/bin/bash
# Wait a few seconds for KWallet to fully initialize
sleep 5
export SSH_ASKPASS=/usr/bin/ksshaskpass
export SSH_ASKPASS_REQUIRE=prefer

# Finds all files without a .pub extension and attempts to load them
for key in ~/.ssh/id_*; do
    if [[ "$key" != *.pub ]]; then
        ssh-add "$key" </dev/null
    fi
done
