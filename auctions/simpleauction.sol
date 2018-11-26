pragma solidity^0.4.25;

contract SimpleAuction {
    
    address seller;
    address highestBidder;
    uint highestBid;
    uint today;
    uint duration;
    uint bidnumber;
    
    struct Bid {
        address bidder;
        uint bidvalue;
    }
    
    Bid[] public bids;
    
    constructor() public {
        seller = msg.sender;
        highestBid = 0;
        today = block.timestamp;
        bidnumber = 0;
        duration = 0;
    }
    
    function setAuctionDuration(uint _time) public {
        require (msg.sender == seller);
        duration = today + (_time);
    }
    
    function submitBid() public payable returns (uint) {
        require (block.timestamp < duration);
        require (msg.value > 0);
        require (msg.value > highestBid);
        highestBid = msg.value;
        highestBidder = msg.sender;
        bids.push(Bid(msg.sender, msg.value));
        bidnumber++;
        return bidnumber;
    }
    
    function seeHighestBid() public view returns(uint, address){
        return (highestBid, highestBidder);
    }
    
    function hasAuctionEnded() internal view returns (bool) {
        if (block.timestamp > duration) return true;
        else return false;
    }
    
    function endAuction() public {
        require (hasAuctionEnded() == true);
        seller.transfer(highestBid); 
    }
    
    function giveMeMyMoneyBack(uint _bidn) public {
        require (msg.sender != highestBidder);
        require (msg.sender == bids[_bidn].bidder);
        (msg.sender).transfer(bids[_bidn].bidvalue); 
    }
   
}
