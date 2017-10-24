pragma solidity ^0.4.11;

/*
    Lottery factory
    - accept incoming deposits from Bikes
        - payload has: lat/long in uint32
    - makes instances of Lottery
        - with lat/long rounded to 1 decimal
        - it's own adress, in case lottery expires

    Lottery
    - accept incoming deposits from Lottery-factory (mvp: bike)
    - has property: lat/long
    - has property: list of subscribers
    - when condition is met: wire all funds to random subscriber
    - when there are no shops.. what to do?
        - the over-budger: refund to the Lottery-factory

    example precision: 1 decimal
    Rotterdam 
    51.9, 4.4
    


*/

contract Lottery {

    address[] shops;
    uint public depositTotal = 0;

    address owner; //the owner of the contract will be LotteryFactory

    function Lottery() payable public {
        owner = msg.sender; // LotteryFactory
    }
    
    //a bike makes a deposit to this lottery, will be LotteryFactory eventually
    function Deposit() payable public  {
        if (msg.value > 0) {
            depositTotal += msg.value;
        }
        if (depositTotal > 1 ether){
            EndLottery();
        }
    }

    //a shop enters lottery to win upcoming bike.
    function Enter() public{
        shops.push(msg.sender);      
    }

    
    //end the lottery
    function EndLottery() private {
        uint winningNumber = uint(block.blockhash(block.number-1)) % shops.length + 1;
        selfdestruct(shops[winningNumber]);
        return; 
          
    }
    
}