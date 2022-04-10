//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract structpractice{

    uint public peopleCount;

    //declaring a People map of 'uint' keys and 'person' values
    mapping(uint => person) public People;

    address public Owner;

    //the constructor is used to set values at the beginning of the constract
    constructor() {
        Owner = msg.sender;
    }

    //creating a modifier to set visibility orpermission for functions
    modifier onlyOwner{
        //the 'require' tests the comparison
        //If true, it returns 'true', else it throws an error with a reason
        require(msg.sender == Owner, "Only the Contract Owner is allowed to add users");
        _;
    }

    struct person{
        uint _id;
        string _firstName;
        string _lastName;
    }

    function addPeople(string memory _firstName, string memory _lastName) public onlyOwner {
        peopleCount += 1;
        People[peopleCount] = person(peopleCount, _firstName, _lastName);
    }

}