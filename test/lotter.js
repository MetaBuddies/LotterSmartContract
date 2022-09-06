//Contract test file example,
// this file selects the method you want to test for the dynamic file and generates test code,
// we provide some examples
const LotterNft = artifacts.require("Lotter.sol");
contract("Lottery", accounts => {
    let lotteryNft;
    beforeEach(async () => {
        lotteryNft = await LotterNft.deployed();
        console.log(lotteryNft.address);
    });

    it("Should make first account an owner on ", async () => {
        let owner = await lotteryNft.owner();
        assert.equal(owner, accounts[0]);
    });

    it("Should get contract name", async () => {
        let lotterNft = await LotterNft.deployed();
        let name = await lotterNft.name();
        assert.equal(name, "Lotter");
    });

    it("Should get contract owner", async () => {
        let lotterNft = await LotterNft.deployed();
        let owner = await lotterNft.owner();
        assert.equal(owner, accounts[0]);
    });

});
