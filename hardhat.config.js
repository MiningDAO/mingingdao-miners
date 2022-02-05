require('@nomiclabs/hardhat-waffle');
require('hardhat-contract-sizer');
require('hardhat-gas-reporter');
require('hardhat-deploy');
require("@nomiclabs/hardhat-etherscan");
require('hardhat-deploy-ethers');
require('./tasks/wrapped.js');
require('./tasks/nft.js');
require('./tasks/agent.js');

const config = require('./config');
extendEnvironment((hre) => {
    hre.localConfig = config;
});

task('accounts', 'Prints the list of accounts')
    .setAction(async (taskArgs, { ethers }) => {
        const signers = await ethers.getNamedSigners();
        for (const name of Object.keys(signers)) {
          formatted = (name + ": ").padEnd(15, " ");
          console.log(formatted + signers[name].address);
        }
    });

task('abi', 'Prints abi of contract')
    .addParam('contract', 'contract name')
    .setAction(async (taskArgs, { artifacts }) => {
        let artifact = await artifacts.readArtifact(taskArgs.contract);
        console.log(JSON.stringify(artifact.abi));
    });

module.exports = {
    solidity: '0.8.4',
    networks: {
        matic: {
            live: true,
            url: config.alchemy.matic,
            chainId: 137,
            accounts: config.accounts
        },
        maticdev: {
            live: true,
            url: config.alchemy.maticdev,
            chainId: 80001,
            accounts: config.accounts
        },
        bscdev: {
            url: "https://data-seed-prebsc-1-s1.binance.org:8545",
            chainId: 97,
            gasPrice: 10000000000,
            accounts: config.accounts
        },
        bsc: {
            url: "https://bsc-dataseed.binance.org/",
            chainId: 56,
            gasPrice: 5000000000,
            accounts: config.accounts
        }
    },
    etherscan: {
        apiKey: {
            bsc: config.scan.bsc.key,
            bscTestnet: config.scan.bscdev.key
        }
    },
    namedAccounts: {
        deployer: {
            default: 0
        },
        admin: {
            default: 1
        },
        custodian: {
            default: 2
        },
        alchemist: {
            default: 3
        }
    },
    gasReporter: {
        enabled: config.enableGasReporter,
        currency: 'USD',
        coinmarketcap: '1c5db8be-2272-42c9-8d48-51a072cdc5a1',
        gasPrice: 90
    },
    settings: {
        optimizer: {
            enabled: true,
            runs: 100,
        },
    },
    path: {
        deploy: 'deploy',
        deployments: 'deployments'
    }
};
