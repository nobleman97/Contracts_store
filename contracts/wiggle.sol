//SPDX-Lincense-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract wiggle{

    enum Report {Waiting, Ready, Active}
    Report public tellMe;

    constructor(){
        tellMe = Report.Waiting;
    }

    function activate() public{
        tellMe = Report.Active;
    }

    function isActive()public view returns(bool){
        return tellMe == Report.Active;
    }
}