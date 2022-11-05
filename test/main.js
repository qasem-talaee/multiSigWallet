const Main = artifacts.require("Main");

contract("Main", function (accounts) {

    const Admin = accounts[0];
    const addArray = [accounts[1], accounts[2]];
    const password = "12345678";
    let instance;
    let multiSig;

    it("should create a multiSig wallet", async function () {
        instance = await Main.deployed();
        multiSig = await instance.addMultiSig(password, addArray);
    });

    it("should return multiSig wallet address", async function () {
        const address = await instance.getAddress(password);
    });

    it("should charge multiSig wallet", async function () {
        await instance.chargeWallet(password, {from:accounts[1], value: web3.utils.toWei('10')});
    });

    it("should submit transaction", async function () {
        await instance.submitTransaction(password, accounts[3], web3.utils.toWei('9'), {from: accounts[1]});
    });

    it("should confirm transaction", async function () {
        await instance.confirmTransaction(password, 0, {from: accounts[1]});
        await instance.confirmTransaction(password, 0, {from: accounts[2]});
    });

    it("should execute transaction", async function () {
        await instance.executeTransaction(password, 0, {from: accounts[1]});
    });

});