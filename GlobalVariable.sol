// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract GlobalVars{
    // the current time as a timestamp (second from 01 Jan 1970)
    uint public this_moment = block.timestamp;  // 'now' is deprecated and is an alias to block.timestamp

    // the current block number
    uint public block_number = block.number;

    // the current block difficulty
    uint public difficulty = block.difficulty;

    // the block gas limit
    uint public gasLimit = block.gaslimit;

    address public owner;
    uint public sentValue;

    constructor(){
        // msg.sender is the address that interacts with the contract (deploys it in this case)
        owner = msg.sender;
    }

    function changeOwner() public {
        // msg.sender is the address that interacts with the contract (calls the function in this case)
        owner = msg.sender;
    }

    // must be payable to receive ETH with the transaction
    function sendEther() public payable {
        // msg.value is the value of wei sent in this transaction (when callign the function)
        sentValue = msg.value;
    }

    // returning the balance of the contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}