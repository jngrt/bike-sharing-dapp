App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load pets.
    $.getJSON('../bikes.json', function(data) {
      var bikes = $('#bikes');
      var templ = $('#template');

      for (i = 0; i < data.length; i ++) {
        templ.find('.panel-title').text(data[i].name);
        templ.find('img').attr('src', data[i].picture);
        templ.find('.btn-rent').attr('data-id', data[i].id);
        bikes.append(templ.html());
      }
    });

    return App.initWeb3();
  },


  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // If no injected web3 instance is detected, fallback to the TestRPC.
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('BikeRent.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var artifact = data;
      App.contracts.BikeRent = TruffleContract(artifact);

      // Set the provider for our contract.
      App.contracts.BikeRent.setProvider(App.web3Provider);

      return App.markRented();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-rent', App.handleRent);
  },

  markRented: function(renters, account) {
    var templ = $('#template');
    var contractInstance;

    App.contracts.BikeRent.deployed().then(function(instance) {
      contractInstance = instance;

      return contractInstance.getRenters.call();
    }).then(function(renters) {
      for (i = 0; i < renters.length; i++) {
        if (
          renters[i] !== '0x0000000000000000000000000000000000000000' &&
          renters[i] !== '0x'
      ) {
          $('.panel-bike').eq(i).find('button').text('Rented out').attr('disabled', true);
          $('.panel-bike').eq(i).find('.renter').text(renters[i]);
        }
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  handleRent: function(e) {
    e.preventDefault();

    var id = parseInt($(e.target).data('id'));

    var contractInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log(account);

      App.contracts.BikeRent.deployed().then(function(instance) {
        contractInstance = instance;

        return contractInstance.rent(id, {from: account});
      }).then(function(result) {
        return App.markRented();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
