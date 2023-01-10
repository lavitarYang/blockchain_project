var MainContract = artifacts.require('./MainContract.sol');
// var testSyntax = artifacts.require('./TestSyntax.sol');
// var HelperFunction = artifacts.require('./HelperFunction.sol');
var Bank = artifacts.require("Bank.sol");
contract("deployer", () => {
    // it('bank', async () => {
    //     const bank = await Bank.deployed();
    //     assert(bank.address !== {});
    // });
    it("MainContract", async () => {
        const maincontract = await MainContract.deployed()
        assert(maincontract.address !== {});
    });
    // it("testSyntax", async () => {
    //     const testsyntax = await testSyntax.deployed()
    //     assert(testsyntax.address !== {});
    // });
    // it('HelperFunction', async () => {
    //     const helperfunction = await HelperFunction.deployed();
    //     assert(helperfunction.address !== {});
    // });
});
// since it's not allow to test internal function that I crop those functionality into HelperFunction.sol
// then, success by testSyntax.sol
// contract("Helperfunction  ", async () => {
//     it("getseed", async () => {
//         const app = await HelperFunction.deployed();
//         const result = await app.getseed();
//         assert(result.words[0] === 0);
//     });
//     it("random", async () => {
//         const app = await HelperFunction.deployed();
//         await app.random();
//         const result = await app.getseed();
//         assert(result.words[0] !== 0)
//     });
// });
//maincontract
contract("MainContract", async () => {
    //shop
    it("default shop value", async () => {
        const app = await MainContract.deployed();
        const shop = await app.getShop(0);
        // console.log(shop[0]);
        assert(shop[0].words[0] === 10 && shop[1].words[0] === 15);
    });
    it("random setshop module", async () => {
        const app = await MainContract.deployed();
        await app.set_Shop_Storage();
        const shop = await app.getShop(0);
        assert(shop[0] !== 0 && shop[1] !== 0);
    });
    //player before started
    it("player sender function ",async ()=>{
        const app = await MainContract.deployed();
        const accounts = await web3.eth.getAccounts();
        await app.playerSender(app.address,{from:accounts[3],value:web3.utils.toWei('0.0000000000005','Ether')});
        const balance = await app.balanceOfContract();
        assert(balance.words[0]===500000);
    });
    it("player chose shop function",async ()=>{
        const app = await MainContract.deployed();
        const accounts = await web3.eth.getAccounts();
        await app.chooseShop(1,{from:accounts[1]});
        const playerState = await app.getPlayerState(accounts[1]);
        assert(playerState.business==='1');
    });
    it("player init function ",async ()=>{
        const app = await MainContract.deployed();
        const accounts = await web3.eth.getAccounts();
        await app.chooseShop(1,{from:accounts[5]});
        await app.playerSender(app.address,{from:accounts[5],value:web3.utils.toWei("0.00000000005","Ether")});
        await app.initPlayerState({from:accounts[5]});
        const playerState=await app.getPlayerState(accounts[5]);
        assert(playerState.partin === true);
    });
    //bank 
    // it("set up bank utility", async () => {
    //     const bank = await Bank.deployed();
    //     const maincontract = await MainContract.deployed();
    //     await maincontract.depoBank(bank.address);
    //     const response = await maincontract.Bank_response()
    //     assert(response === "hello");
    // });
    // it("get balance withinmain", async () => {
    //     const bank = await Bank.deployed();
    //     const maincontract = await MainContract.deployed();
    //     const accounts = await web3.eth.getAccounts();
    //     await maincontract.depoBank(bank.address);
    //     await bank.deposit({ from: accounts[3], value: web3.utils.toWei('0.00000000000025', 'Ether') });
    //     let balance = await maincontract.Bank_getbalance({ from: accounts[3] });
    //     assert(balance.words[0] === 250000);
    // });
    // it("deposit first time within main",async()=>{
    //     const bank = await Bank.deployed();
    //     const main = await MainContract.deployed();
    //     const accs = await web3.eth.getAccounts();
    //     await main.depoBank(bank.address);
    //     await main.Bank_deposit({from:accs[4],value:web3.utils.toWei('0.00000000000025',"Ether")});
    //     // await bank.deposit({ from: accs[4], value: web3.utils.toWei('0.00000000000025', 'Ether') });

    //     const balc= await main.Bank_getbalance({from:accs[4]});
    //     console.log(balc);
    //     assert(balc.words[0]===250000);
    // });

});
// contract("bank itself", async () => {
//     it("get balance as default", async () => {
//         const accounts = await web3.eth.getAccounts();
//         const app = await Bank.deployed();
//         const result = await app.getbalance({ from: accounts[0] });
//         assert(result.words[0] === 0);
//     });
//     it("withdraw as defalut should fail work on balance not enough either", async () => {
//         const accounts = await web3.eth.getAccounts();
//         const app = await Bank.deployed();
//         try {
//             await app.withdraw(web3.utils.toWei('5', 'Ether'));
//         }
//         catch (err) {
//             assert(err.reason === "not enought money");
//         }
//     });
//     it("deposit as default should be valid", async () => {
//         const accounts = await web3.eth.getAccounts();
//         const app = await Bank.deployed();
//         await app.deposit({ from: accounts[5], value: web3.utils.toWei('0.00000000000025', 'Ether') });
//         const bignumb = await app.getbalance({ from: accounts[5] });
//         assert(bignumb.words[0] ===250000);
//     });
//     it("deposit twice should be invalid ", async () => {
//         const accounts = await web3.eth.getAccounts();
//         const app = await Bank.deployed();
//         try {
//             await app.deposit({ from: accounts[5], value: web3.utils.toWei('0.00000000000025', 'Ether') });
//         }
//         catch (err) {
//             assert(err.reason === "can only interest once");
//         }
//     });

// });
