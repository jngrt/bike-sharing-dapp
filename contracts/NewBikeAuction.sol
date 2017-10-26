pragma solidity ^0.4.17;


contract NewBikeAuction {

   event LogTest(string test);
   event LogAddress(address a);
   event LogUint(uint u);
  
 
   function setValue() payable public returns (uint){
       LogUint(this.balance);
       return msg.value;
   }
  
  function getBalance() public view returns (uint) {
    return this.balance;
  }
  function collect( address winner ) public {
      LogTest('collect');
      selfdestruct( winner );
  }
  function getTest() public returns (uint) {
      LogTest('testing');
      return 777;
  }
}
