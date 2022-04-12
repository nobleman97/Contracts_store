//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract itemAuction{
    //State variables
    address internal owner;
    address public theSeller; //the person the seller of item
    uint public startBlock;
    uint public endBlock;
    uint public highestBid;
    uint public initialPrice;
    address public winner;


    //reference data
    mapping(address => uint) public balances;
    event statusReport(string response, address to);
    enum State{CLOSED, OPEN}
    State internal currState;

    //modifiers
    modifier onlyOwner(){
        require(msg.sender == owner, "Only contratct owner can do this");
        _;
    }

    modifier onlySeller(){
        require(msg.sender == theSeller, "Only the seller can call this funtion");
        _;
    }

    modifier ownerOrSeller(){
        require(msg.sender == owner || msg.sender == theSeller, "only seller or manager can call this function");
        _;
    }

    modifier notSeller(){
        require(msg.sender != theSeller, "Seller cannot call this function");
        _;
    }

    modifier notOwner(){
        require(msg.sender != owner, "owner cannot call this function");
        _;
    }

    /*
    modifier whenOpen(){
        require(end < block.timestamp, "auction is not yet open / has closed" );
        _;
    }

    modifier whenClosed(){
        require(endBlock < block.timestamp, "Auction is still open");
        _;
    }*/


    /*Functions:
    - initiateAuction
    - bid()
    - withdraw()
    - endAuction()
    */

    constructor(){
        owner = msg.sender;
    }

    function initateAuction(address _theSeller, uint _initialPrice, uint _startBlock, uint _endBlock) public onlyOwner{
       require(currState == State.CLOSED, "The auction is still open. End it to restart again");
        startBlock = _startBlock;
        endBlock = _endBlock;
        theSeller = _theSeller;
        initialPrice = _initialPrice;
        highestBid = (1 ether) * initialPrice;

       currState = State.OPEN;
    }

    function bid()public payable notSeller notOwner {
        require(currState == State.OPEN, "Auction is closed");
        if(msg.value == 0 * (1 ether)){
            revert("Enter a valid amount");
        }

        uint newBid = balances[msg.sender] += msg.value;

        if(newBid <= highestBid){
            revert("your bid is currently too low.");
        }else if(newBid > highestBid){
            highestBid = newBid;
            balances[msg.sender] = newBid;
            winner = msg.sender;
        }


    }

    function withdrawBid()public notSeller notOwner{
        require(msg.sender != winner, "You currently can't withdraw. You are the highest bidder.");
        require(balances[msg.sender] != 0, "You did not contribute for this auction");

        //note the caller's balance and clean his records
        uint callerBalance = balances[msg.sender];
        balances[msg.sender] = 0;

        //send his ETH back to him. If that fails, re-record his balance
        if(payable(msg.sender).send(callerBalance)){
            emit statusReport("ETH sucessfully returned", msg.sender);
        }else{
            balances[msg.sender] = callerBalance;
        }

    }

    function endAuction()public ownerOrSeller{

        //determine how much the highest bidder bid
       uint finalPrice = balances[winner];

        //send that amount to the theSeller(seller)
       if(payable(theSeller).send(finalPrice)){
           emit statusReport("transferred funds to theSeller", msg.sender);
            balances[winner] -= finalPrice;
       }else{

           //if the transaction fails, restore the winner's original balance
           balances[winner] = finalPrice;
       }

       currState = State.CLOSED;
    }


}