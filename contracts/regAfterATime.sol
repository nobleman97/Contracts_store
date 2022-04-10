//SPDX-License-Identifier: MIT;

pragma solidity ^0.8.4;

contract registrationAfterATime{
    //This contract will not let you register people until the start time has passed

    Person[] public people;

    uint public peopleCount;

    uint startTime = ______; //insert epoch time value here

    modifier onlyWhenOpen(){
        //block.timestamp gives the value of the present epoch time

        require(block.timestamp >= startTime);
        _;
    }

    struct Person{
        uint _id;
        string _firstName;
        string _lastName;
    }

    function addPeople(uint memory id, string memory firstName, string memory lastName)public onlyWhenOpen{
        people.push(Person(id, firstName, lastName));
        peopleCount += 1;
    }


}