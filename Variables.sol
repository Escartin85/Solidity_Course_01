// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Property {
    // declaring state variables saved in contract's storage
    uint price;  // by default is private
    string public location;

    // can be initialized at declaration or in the constructor only
    address immutable public owner;

    // declaring a constant
    int constant area = 100;

    // declaring the constructor
    // is executed only once at contract's deployment
    constructor(uint _price, string memory _location){
        price = _price;
        location = _location;
        // initializing owner to the account's address that deploys the contract
        owner = msg.sender;
    }

    // getter function, returns a state variable
    // a function declared 'view' does not alter the blockchain
    function getPrice() public view returns(uint){
        return price;
    }

    // setter function, sets a state variable
    function setPrice(uint _price) public{
        int a;      // local variable saved on stack
        a = 10;
        price = _price;
    }
    
    // string types must be declared memory or storage
    function setLocation(string memory _location) public{
        location = _location;
    }
}