#! /bin/bash
EL_PORT=$(kurtosis enclave inspect my-testnet | grep 8545/tcp | tr -s ' ' | cut -d " " -f 5 | sed -e 's/127.0.0.1\://' | head -n 1)
echo "EL Node port is $EL_PORT"

cd $ENS_LOCATION

cat >.env <<EOL
EL_PORT=$EL_PORT
EOL

echo "generated .env"

yarn hardhat --network localhost deploy --reset

ENS_VALID_REGISTRAR_CONTRACTS=$(cat deployments/localhost/ETHRegistrarController.json | jq .address)
echo "ENS Registrar is at address $ENS_VALID_REGISTRAR_CONTRACTS"

# We can't export env variables from a VSCode task, so let's use a file
cd -
echo "ENS_VALID_REGISTRAR_CONTRACTS=$ENS_VALID_REGISTRAR_CONTRACTS" > .env