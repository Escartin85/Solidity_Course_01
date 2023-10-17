// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Deposit {
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    // either received() or fallback() is manatory for the contract to receive ETH by sending ETH to the contract's address

    // declaring the receive() funtion that is executed when sending ETH to the contract address it was introduced in Solidity 0.6
    // and a contract can have only one recive function
    // declared with this syntax (without the function keyword and without arguments)
    receive() external payable { }

    // declaring a fallback payable funtion is called when msg.data is not empty or when no other function mathes
    fallback() external payable { }

    // returning the balance of the contract
    function getBalance() public view returns(uint){
        // this is the current contract, explicitly convertible to address, and balance is a member of any variable of type address
        return address(this).balance;
    }

    // ether can be send and received by the contract in the transaction that calls this function as well
    function sendEther() public payable{
        uint x;
        x++;
    }

    // transfering ether from the contract to another address (recipient)
    function transferEther(address payable recipient, uint amount) public returns(bool){
        // checking that only contract owner can send ether from the contract to another address
        require(owner == msg.sender, "Transfer failed, you are not the owner");

        if(amount <= getBalance() ){
            // transfering the amount of wei from the contract to the recipient address
            // anyone who can call thsi function have access to the contract's funds
            recipient.transfer(amount);
            return true;
        }else{
            return false;
        }
    }


}