var MainContract = artifacts.require("MainContract");
// var bank = artifacts.require("Bank.sol")
// var testSyntax = artifacts.require("TestSyntax");
// var helperFunction = artifacts.require("HelperFunction");
module.exports = function(deployer){
    deployer.deploy(MainContract);
    // deployer.deploy(bank);
    //     deployer.deploy(testSyntax);
    //     deployer.deploy(helperFunction);
}