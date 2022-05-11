require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
const dotenv = require("dotenv");

dotenv.config();

module.exports = {
  solidity: "0.8.7",
  defaultNetwork: "rinkeby",
  networks: {
    rinkeby: {
      url: process.env.INFURA_API_URL,
      accounts: [process.env.PRIVATE_RINKEBY_ACCOUNT_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY,
  },
};
