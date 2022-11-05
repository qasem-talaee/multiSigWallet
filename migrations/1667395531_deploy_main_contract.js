const Main = artifacts.require('Main');
 
module.exports = function(deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(Main);
};