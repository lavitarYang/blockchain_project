var MainContract = artifacts.require("MainContract");
var bank = artifacts.require("Bank.sol")
module.exports = function(deployer){
    deployer.deploy(MainContract);
    deployer.deploy(bank);
}