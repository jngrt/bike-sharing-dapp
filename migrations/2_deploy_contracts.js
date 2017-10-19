var BikeRent = artifacts.require("./BikeRent.sol");

module.exports = function(deployer) {
  deployer.deploy(BikeRent);
};
