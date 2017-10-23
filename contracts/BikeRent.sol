pragma solidity ^0.4.17;

import 'MultipleOwners.sol';
import 'NewBikeAuction.sol';

contract BikeRent is MultipleOwners, mortal {

  address[6] public renters;
  BikeShop[] public bikeshops;
  mapping(address => bool) isBikeShop;
  Bike[] public bikes;
  uint public price = 500 finney;
  uint public bikePrice = 1 ether;
  uint private balance;
  NewBikeAuction[] auctions;

  modifier onlyBikeShops {
      require(isBikeShop[msg.sender]);
      _;
  }

  //TODO: list of all bikes
  //probably list of addresses.. how should bikes be identified



  //TODO: keep track of rentals
  struct RentalAction{
    address renter;
    address bike;
    uint rentStart;
    uint rentEnd;
  }

  struct BikeShop{
      address shop;
      // storing location as ints, shift decimal point 6 places
      int32 lat;
      int32 long;
  }

  struct Bike {
      address bike;
      int32 lat;
      int32 long;
  }

  function BikeRent( uint priceInFinney ) public {
      price = priceInFinney * 1 finney;
  }

  //kill should be added automatically by remix?..
  function kill() public onlyOwners {
    selfdestruct(msg.sender);
  }

  // Renting a bike
  function rent(uint bikeId) public payable returns (uint) {
    //if invalid bikeId return the eth
    require(bikeId >= 0 && bikeId <= 6);

    // if not enough paid: return the eth
    require(msg.value >= price );

    // update our running total
    // should not be necessary, SC should have balance already
    // http://solidity.readthedocs.io/en/latest/types.html?highlight=send%20ether#members-of-addresses
    //balance += msg.value;

    // register the bike rented
    renters[bikeId] = msg.sender;

    // check if we can buy a new bike
    checkFunds();

    return bikeId;
  }

  function checkFunds() private {
    if( balance >= bikePrice ){
      //NewBikeAuction
      NewBikeAuction nba = NewBikeAuction.call.value(bikePrice)('NewBikeAuction',owners);
      auctions.push(nba);
    }
  }

  function getAuctions() public view returns( NewBikeAuction[] ){
    return auctions;
  }

  // Retrieving the adopters
  function getRenters() public view returns (address[6]) {
    return renters;
  }

  // Retrieving the bikeshops
  function getBikeshops() public view returns (BikeShop[]) {
    return bikeshops;
  }

  // adding a bikeshop, can only be done by owners of the contract
  function addBikeshop( address bikeshop, int32 lat, int32 long )
    public onlyOwners returns (uint)
  {
    return(bikeshops.push( BikeShop(bikeshop, lat, long) ));
  }

  function addBike( address bike, int32 lat, int32 long)
    public onlyBikeShops returns(uint)
  {
      return(bikes.push( Bike(bike, lat, long)));
  }

}
