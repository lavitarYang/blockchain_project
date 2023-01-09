var testSyntax = artifacts.require("TestSyntax");
var helperFunction = artifacts.require("HelperFunction");
var tester = artifacts.require("Runner.sol");
module.exports=function(deployer){
    deployer.deploy(testSyntax);
    deployer.deploy(helperFunction);
    deployer.deploy(tester);
}