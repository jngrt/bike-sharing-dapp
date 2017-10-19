pragma solidity ^0.4.4;

contract BikeRent {
  // list of addresses who can add bikeshops?...
  mapping(address => bool) public owners;

  address[6] public renters;
  address[] public bikeshops;

  uint public price;

  //TODO: list of all bikes
  //probably list of addresses.. how should bikes be identified

  //TODO: keep track of rentals
  struct RentalAction{
    address renter;
    uint rentStart;
  }

  function BikeRent( uint priceInFinney ){
      owners[msg.sender] = true;
      price = priceInFinney * 1 finney;
  }
  function kill(){
      if ( owners[msg.sender] ){
          selfdestruct(msg.sender);
      }
  }

  // Renting a bike
  function rent(uint bikeId) public returns (uint) {
    //if invalid bikeId return the eth
    require(bikeId >= 0 && bikeId <= 6);

    // if not enough paid: return the eth
    require(msg.value >= price );

    renters[bikeId] = msg.sender;

    return bikeId;
  }

  // Retrieving the adopters
  function getRenters() public returns (address[6]) {
    return renters;
  }

  // Retrieving the bikeshops
  function getBikeshops() public returns (address[]) {
    return bikeshops;
  }

  // adding a bikeshop, can only be done by owners of the contract
  function addBikeshop( address bikeshop ) public returns (uint) {
    if( owners[msg.sender] ) {
      uint index = bikeshops.push( bikeshop );
      return(index);
    }
  }


}
