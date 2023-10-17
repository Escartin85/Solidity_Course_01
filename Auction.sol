// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Auction {
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    
    // variable for control the state of the Bid
    enum State {Started, Running, Ended, Canceled}
    State public auctionState;

    // variables for control the highest bid
    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;
    
    uint bidIncrement;

    // the owner can finalize the auction and get the highestBindingBid only once
    bool public ownerFinalized = false;

    constructor(){
        owner = payable(msg.sender);
        auctionState = State.Running;

        // to calculate the time 1 week => 60 * 60  * 24 * 7 = 604800 seconds in 1 week | 604800 / 15 (blocks) = 40320 Blocks in 1 week
        startBlock = block.number;
        endBlock = startBlock + 40320;

        ipfsHash = "";
        // bidding in multiple of ETH
        bidIncrement = 100;
    }

    // declaring function modifiers
    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    modifier afterStar(){
        require(block.number >= startBlock);
        _;
    }
    modifier beforeEnd(){
        require(block.number != endBlock);
        _;
    }
    // a helper pure function (it neither reads, nor it writes to the blockchain)
    function min(uint a, uint b) pure internal returns(uint){
        if (a <= b){
            return a;
        }else{
            return b;
        }
    }
    // only the owner can cancel the Auction before the Auction has ended
    function cancelAuction() public beforeEnd onlyOwner{
        auctionState = State.Canceled;
    }

    // the main function called to place a bid
    function placeBid() public payable notOwner afterStar beforeEnd returns(bool){
        // to place a bid auction should be running
        require(auctionState == State.Running);
        // minimum value allowed to be sent
        // require(msg.value > 0.0001 ether);

        uint currentBid = bids[msg.sender] + msg.value;

        // the currentBid should be greater than the highestBindingBid
        // Otherwise there's nothing to do
        require(currentBid > highestBindingBid);

        // updating the mapping variable
        bids[msg.sender] = currentBid;

        // highestBidder remains
        if(currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }else{
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
        return true;
    }

    function finalizeAuction() public{
        // the action has been Canceled or Ended
        require(auctionState == State.Canceled || block.number > endBlock);

        // only the owner or a bidder can finalize the auction
        require(msg.sender == owner || bids[msg.sender] > 0);

        // the recipient will get the value
        address payable recipient;
        uint value;

        // auction canceled, not ended
        if(auctionState == State.Canceled){
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        // action ended, not canceled
        }else{
            // the owner finalizes the auction
            if(msg.sender == owner && ownerFinalized == false){
                recipient = owner;
                value = highestBindingBid;

                // the owner can finalize the auction and get the highestBinding only once
                ownerFinalized = true;
            // another user (not the owner) finalizes the auction
            }else{
                if(msg.sender == highestBidder){
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                // this is neither the owner not the highest bidder (it's a regular bidder)
                }else{
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }

            // reseting the bids of the recipient to avoid multiple transfers to the same recipient
            bids[recipient] = 0;

            // sends value to the recipient
            recipient.transfer(value);
        }
    }
}