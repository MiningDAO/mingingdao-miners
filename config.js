require('dotenv').config();
const fs = require('fs');
const path = require('path');

const config = {
    tokenUri: {
        btc: 'https://www.demine.com/nft/btc/',
        eth: 'https://www.demine.com/nft/eth/',
        fil: 'https://www.demine.com/nft/fil/'
    },
    royaltyBps: 100,
    accounts: [
        process.env.DEPLOYER,
        process.env.ADMIN,
        process.env.CUSTODIAN,
        process.env.ALCHEMIST
    ],
    statePath: path.join(__dirname, './state/'),
    alchemy: {
        matic: process.env.ALCHEMY_MATIC,
        maticdev: process.env.ALCHEMY_MATIC_DEV
    },
    custodian: {
        bsc: '0x427119f5080320Da94B78BB55d75fb48B708346e'
    },
    hashPerToken: {
        btc: 1000000000000,
    },
    antpool: {
        api: 'https://antpool.com/api/',
        userId: process.env.ANTPOOL_SIGN_ID,
        key: process.env.ANTPOOL_KEY,
        secret: process.env.ANTPOOL_SECRET,
        feePercent: 0.005,
    },
    binance: {
        prod: {
            key: process.env.BINANCE_KEY,
            secret: process.env.BINANCE_SECRET,
            api: 'https://api.binance.com'
        },
        test: {
            key: process.env.BINANCE_TEST_KEY,
            secret: process.env.BINANCE_TEST_SECRET,
            api: 'https://testnet.binance.vision'
        }
    },
    scan: {
        bsc: {
            api: "https://api.bscscan.com/api",
            key : process.env.BSC_SCAN_KEY
        },
        bscdev: {
            api: "https://api-testnet.bscscan.com/api",
            key: process.env.BSC_SCAN_KEY
        }
    },
    wrapped: {
        usd: {
            name: 'DeMine Wrapped USD',
            symbol: 'DPAY',
            decimals: 6
        },
        btc: {
            name: 'DeMine Wrapped BTC',
            symbol: 'DBTC',
            decimals: 8
        },
        eth: {
            name: 'DeMine Wrapped ETH',
            symbol: 'DETH',
            decimals: 18
        },
        fil: {
            name: 'DeMine Wrapped FIL',
            symbol: 'DFIL',
            decimals: 18
        }
    },
    enableGasReporter: true
};

module.exports = config;
