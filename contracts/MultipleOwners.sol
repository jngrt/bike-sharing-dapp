pragma solidity ^0.4.17;

contract MultipleOwners {

    mapping(address => bool) public isOwner;

    function MultipleOwners() public {
        isOwner[msg.sender] = true;
    }
    function addOwner(address newOwner) public onlyOwners {
      isOwner[newOwner] = true;
    }

    modifier onlyOwners {
        require(isOwner[msg.sender]);
        _;
    }
}
