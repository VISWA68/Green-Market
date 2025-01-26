const GreenCreditPlatform = artifacts.require("GreenCreditPlatform");

module.exports = function (deployer, network, accounts) {
  deployer.deploy(GreenCreditPlatform, accounts[0]);
};
