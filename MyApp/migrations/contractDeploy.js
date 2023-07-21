var MyAppContract = artifacts.require('MyAppContract');

module.exports = function (deployer) {
  deployer.deploy(MyAppContract);
};
