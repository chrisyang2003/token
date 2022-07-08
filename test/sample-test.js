const { expect } = require("chai");
const { ethers } = require("hardhat");


const sleep = (timeountMS) => new Promise((resolve) => {
  setTimeout(resolve, timeountMS);
});

describe("Destroy", function () {
  it("Should get claimlist", async function () {

    const account = (await ethers.getSigners())[0];
    const address = account.address


    const Destroy = await ethers.getContractFactory("Destroy");
    const destroy = await Destroy.deploy();
    await destroy.deployed();

    // 初始化
    // await destroy.initialize(account.address, 2);

    // console.log(b);
    console.log(await destroy.t1());
    await destroy.burn(500);

    await destroy.burn(10);
    await destroy.burn(20);
    await destroy.burn(30);


    await sleep(6000);
    const res = await destroy.rewardsCount(address);

    console.log("rewardsCount : ", parseInt(res))



    // expect(await greeter.greet()).to.equal("Hello, world!");

    // const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
