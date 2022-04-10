

const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("wiggle");
    const wiggleContract = await waveContractFactory.deploy();
    await wiggleContract.deployed();

    console.log("Contract deployed to:", wiggleContract.address)
    console.log("Contract deployed by:", owner.address);

    let tellStatus; 
    let doActivate;
    let tellMePosition;

    tellStatus = await wiggleContract.tellMe();
    console.log(tellStatus);

    doActivate = await wiggleContract.activate();
    
    tellStatus = await wiggleContract.isActive();
    console.log(tellStatus);

    if (tellStatus == true){
    tellMePosition = await wiggleContract.tellMe();
    console.log("Report is now at position %s", tellMePosition);
    }
};

const runMain = async () => {
    try {
        await main()
        process.exit(0);
    } catch(error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();