// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery{
    // declaring the state variables -> dynamic array of type address
    address payable[] public players;
    address public manager;

    // declaring the constructor
    constructor(){
        // initializing the owner to the address that deploys the contract
        manager = msg.sender;
    }

    // declaring the receive() function that is necessary to receive ETH
    receive() external payable { 
        // each player sends exactly 0.1 ETH
        require(msg.value == 0.1 ether);
        // appending the player to the players array
        players.push(payable (msg.sender));
    }

    // returning the contract's balance in wei
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    // random function hackable by the miner, mining until it founds the block number needed that is what is calculating this function
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // selecting the winner
    function pickerWinner() public {
        // only the manager can pick a winner if there are at least 3 players in the lottery
        require(msg.sender == manager);
        // required at least 3 palyers for get the winner
        require(players.length >= 3);

        uint r = random();
        address payable winner;

        // computing a random index of the array
        uint index = r % players.length;
        // this is the winner
        winner = players[index];
        
        // transfering the entire contract's balance to the winner
        winner.transfer(getBalance());

        // reseting the lottery for the next round
        players = new address payable[](0);
    }
}