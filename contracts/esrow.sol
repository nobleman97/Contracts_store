// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Escrow{

    //Variables
    enum State {NOT_INITIATED, AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETED}

    State public currState;

    bool public isBuyerIn;
    bool public isSellerIn;

    uint public price;

    address public buyer;
    address payable public seller;

    //Modifiers
    modifier onlyBuyer(){
        require(msg.sender == buyer, "Only buyer can call this function");
        _;
    }

    modifier escrowNotStarted(){
        require(currState == State.NOT_INITIATED, 'This Escroe contract might already be in progress');
        _;
    }

    constructor(address _buyer, address payable _seller, uint _price){
        buyer = _buyer;
        seller = _seller;
        price = _price * (1 ether);
    }

    function initContract() public escrowNotStarted{
        if(msg.sender == buyer){
            isBuyerIn = true;
        }

        if(msg.sender == seller){
            isSellerIn = true;
        }

        if(isBuyerIn && isSellerIn){
            currState = State.AWAITING_PAYMENT;
        }
    }

    function deposit() public onlyBuyer payable{
        require(currState == State.AWAITING_PAYMENT, "Already paid or one party not ready");
        require(msg.value == price, "Wrong deposit amount");
        currState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() public onlyBuyer payable{
        require(currState == State.AWAITING_DELIVERY, "Cannot confirm delivery");
        seller.transfer(price);
        currState = State.COMPLETED;
    }

    function withdrawal() public onlyBuyer payable{
        require(currState == State.AWAITING_DELIVERY, "Cannot withdraw at this stage");
        payable(msg.sender).transfer(price);
        currState = State.COMPLETED;
    }
}