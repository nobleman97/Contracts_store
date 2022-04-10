//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract myLottery{
    //this smart contract allows players pool money together
    //and allows contract to randomly decide a winner.
    //only the manager call the pickWinner fn()

    address public manager;
    address[] internal players; //an array to store my players
    uint public numOfParticipants = players.length; //tells us how many players joined so far

    //the manager will be the contract owner
    constructor(){
        manager = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == manager, "Only the manager can check this");
        _;
    }

    function enterLottery() public payable {
        require(msg.value > 0.1 ether, "Sorry. You need minimum of 0.1 ether to participate");
        require(msg.sender != manager, "Sorry manager, you can't participate");
        players.push(msg.sender);
    }

    function randomizer() private view returns(uint){
        return uint (keccak256(abi.encode(block.timestamp, players))); //linter warned me to avoid using timestamp though
    }

    function pickWinner() public onlyOwner{
        uint winner = randomizer() % players.length;

        payable(players[winner]).transfer(address(this).balance);

        players = new address[](0);
    }
}