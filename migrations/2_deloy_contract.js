var testSyntax = artifacts.require("testSyntax");
var helperFunction = artifacts.require("HelperFunction");
var bank = artifacts.require("Bank.sol")
module.exports=function(deployer){
    deployer.deploy(testSyntax);
    deployer.deploy(helperFunction);
    deployer.deploy(bank);

}