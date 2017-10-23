pragma solidity ^0.4.17;

contract NewBikeAuction {

  uint public balance;
  address public testAddress;

  function NewBikeAuction(address _testAddress) public payable {
    testAddress = _testAddress;
    balance = msg.value;
  }

  function kill() public {
    require(testAddress == msg.sender);

    selfdestruct(msg.sender);
  }
  
  function getBalance() public view returns (uint) {
    return balance;
  }

}
