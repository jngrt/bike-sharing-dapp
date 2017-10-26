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

contract LotteryFactory {

    mapping (uint => address) lotteries;

    function LotteryFactory() payable public{

    }
    function deposit(uint location) payable public{
        
        if(lotteries[location] == 0){
            createLottery(location);
        }
        
        return Lottery(lotteries[location]).deposit.value(msg.value)();
        
    }
    function enter(uint location) public{
        if(lotteries[location] == 0){
            createLottery(location);
        }
        return Lottery(lotteries[location]).enter(msg.sender);

    }
    function createLottery(uint location) private {
        lotteries[location] = new Lottery();       
    }

}

contract Lottery {

    address[] public shops;
    uint public depositTotal = 0;

    address factory; //the owner of the contract will be LotteryFactory

    function Lottery() payable public {
        factory = msg.sender; // LotteryFactory
    }
    
    //a bike makes a deposit to this lottery, will be LotteryFactory eventually
    function deposit() payable public  {
        if (msg.value > 0) {
            depositTotal += msg.value;
        }
        if (depositTotal > 1 ether){
            endLottery();
        }
    }

    //a shop enters lottery to win upcoming bike.
    function enter(address caller) public{
        shops.push(caller);      
    }
    
    //end the lottery
    function endLottery() private {
        uint winningNumber = uint(block.blockhash(block.number-1)) % shops.length + 1;
        if(shops.length > 0){
            selfdestruct(shops[winningNumber]);
        }        
        return; 
          
    }
    
}