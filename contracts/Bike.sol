pragma solidity ^0.4.17;


library Shared {
  struct Rental{
    address renter;
    Bike bike;
    uint rentStart;
    uint rentEnd;
  }
}

contract BikeFactory {
  uint public rentalPrice = 0.5 ether;

  function getRentalPrice() public view returns (uint) {
    returns rentalPrice;
  }
}

contract Bike {

  Shared.Rental[] history;
  BikeFactory factory;

  function Bike(BikeFactory f) public {
    factory = f;
  }

  function rent( address renter ) public payable returns (uint) {

    require(msg.value >= f.getRentalPrice() );

    require( isAvailable() );

    history.push(Shared.Rental(renter, this, now, 0 ))

    
  }

  function isAvailable() public view returns (bool) {
    return (history.length == 0 || history[history.length-1].rentEnd != 0);
  }
}
