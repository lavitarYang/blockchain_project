var MainContract = artifacts.require('./MainContract.sol');
var testSyntax = artifacts.require('./testSyntax.sol');
var HelperFunction = artifacts.require('./HelperFunction.sol');
var Bank = artifacts.require("Bank.sol");
contract("deployer",()=>{
    it("MainContract",async ()=>{
        const maincontract = await MainContract.deployed()
        assert(maincontract.address !== {});
    });
    it("testSyntax",async ()=>{
        const testsyntax =await testSyntax.deployed()
        assert(testsyntax.address !== {});
    });
    it('HelperFunction',async()=>{
        const helperfunction =await HelperFunction.deployed();
        assert(helperfunction.address !=={});
    });
    it('bank',async()=>{
        const bank = await Bank.deployed();
        assert(bank.address !== {});
    });
});
// since it's not allow to test internal function that I crop those functionality into HelperFunction.sol
// then, success by testSyntax.sol
contract("Helperfunction  ",async()=>{
    it("getseed",async()=>{
        const app = await HelperFunction.deployed();
        const result = await app.getseed();
        assert(result.words[0]===0);
    });
    it("random",async ()=>{
        const app=await HelperFunction.deployed();
        await app.random();
        const result =await app.getseed();
        assert(result.words[0]!==0)
    }); 
});
//maincontract
contract("MainContract",async()=>{
    //shop
    it("default shop value",async()=>{
        const app = await MainContract.deployed();
        const shop= await app.getShop(0);
        // console.log(shop[0]);
        assert(shop[0].words[0]===10 && shop[1].words[0] ===15);
    });
    it("random setshop module",async()=>{
        const app = await MainContract.deployed();
        await app.set_Shop_Storage();
        const shop = await app.getShop(0);
        assert(shop[0]!==0 && shop[1]!==0);
    });
    //player

});
contract("bank",async()=>{
    it("get balance as default",async()=>{
        const accounts = await web3.eth.getAccounts();
        const app =await Bank.deployed();
        const result = await app.getbalance({from:accounts[0]});
        assert(result.words[0]===0);
    });
    it("withdraw as defalut should fail work on balance not enough either",async()=>{
        const accounts = await web3.eth.getAccounts();
        const app =await Bank.deployed();
        try {
            await app.withdraw(web3.utils.toWei('5','Ether'));
        }
        catch (err){
            assert(err.reason === "not enought money");
        }
    });
    it("deposit as default should be valid",async()=>{
        const accounts = await web3.eth.getAccounts();
        const app      = await Bank.deployed();
        await app.deposit({from:accounts[5],value:web3.utils.toWei('0.00000000000025','Ether')});
        let bignumb   = await app.getbalance({from:accounts[5]});
        let compare   = await web3.utils.toWei('0.00000000000025','Ether');
        bignumb=bignumb.words[0].toString();
        assert(compare === bignumb);
    });
    it("deposit twice should be invalid ",async()=>{
        const accounts = await web3.eth.getAccounts();
        const app      = await Bank.deployed();
        try{
            await app.deposit({from:accounts[5],value:web3.utils.toWei('0.00000000000025','Ether')});
        }
        catch (err){
            assert(err.reason === "can only interest once");
        }
    });

});