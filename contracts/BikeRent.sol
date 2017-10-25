pragma solidity ^0.4.17;

import './NewBikeAuction.sol';
import './MultipleOwners.sol';



contract BikeRent is MultipleOwners {

  address[6] public renters;
  BikeShop[] public bikeshops;
  mapping(address => bool) isBikeShop;
  Bike[] public bikes;
  uint public price = 500 finney;
  uint public bikePrice = 1 ether;
  NewBikeAuction[] auctions;

  modifier onlyBikeShops {
      require(isBikeShop[msg.sender]);
      _;
  }


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



  // Renting a bike
  function rent(uint bikeId) public payable returns (uint) {
    //if invalid bikeId return the eth
    require(bikeId >= 0 && bikeId <= 6);

    // if not enough paid: return the eth
    require(msg.value >= price );

    // register the bike rented
    renters[bikeId] = msg.sender;

    // check if we can buy a new bike
    checkFunds();

    return bikeId;
  }

  function checkFunds() private {
    if( this.balance >= bikePrice ){
      
      NewBikeAuction nba = new NewBikeAuction();
      nba.setValue.value(bikePrice)();
      auctions.push(nba);
    }
  }
  function collectAuction(uint index) public {
      //NewBikeAuction auction = auctions[index];
      
      //auction.collect.gas(80000)(msg.sender);
      //auction.collect(msg.sender);
      (auctions[index]).collect(msg.sender);
  }
  

  function getAuctions() public view returns( NewBikeAuction[] ){
    return auctions;
  }
  function setAuctionValue(uint index) payable public returns (uint) {
      return (auctions[index]).setValue.value(msg.value)();
      //return msg.value;
  }
  function getAuctionBalance( uint auctionIndex) public view returns ( uint ){
      return (auctions[auctionIndex]).getBalance();
  }


  // Retrieving the adopters
  function getRenters() public view returns (address[6]) {
    return renters;
  }
  function getBalance() public view returns (uint) {
      return this.balance;
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
