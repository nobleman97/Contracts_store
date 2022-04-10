

const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("structpractice");
    const structsContract = await waveContractFactory.deploy();
    await structsContract.deployed();

    console.log("Contract deployed to:", structsContract.address)
    console.log("Contract deployed by:", owner.address);

    await structsContract.addPeople("David", "Omokhodion");
    structsContract.addPeople("Desmond", "Ezo-Ojile");
    

    let numberOfPeople = await structsContract.peopleCount();

    for(let i = 0; i < numberOfPeople;){
    let viewMap = await structsContract.People(i+1);
    console.log(viewMap);
    ++i;
    }
    
    await structsContract.connect(randomPerson).addPeople("asvasdv", "zcv")
    console.log(structsContract.People(3));
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