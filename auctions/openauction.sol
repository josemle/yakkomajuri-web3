pragma solidity^0.4.25;

contract OpenAuction {
    
    address seller;
    address highestBidder;
    uint highestBid;
    uint today;
    uint duration;
    uint bidnumber;
    bool ended;
    bool settime;
    
    struct Bid {
        address bidder;
        uint bidvalue;
    }
    
    constructor() public {
        seller = msg.sender;
        highestBid = 0;
        today = block.timestamp;
        bidnumber = 0;
        duration = 0;
        ended = false;
        settime = false;
    }
    
    mapping(address => uint) bidReturns;
    
    function setAuctionDuration(uint _time) public {
        require (msg.sender == seller);
        require (settime == false);
        duration = today + (_time);
        settime = true;
    }
    
    function submitBid() public payable {
        require (block.timestamp < duration);
        require (msg.value > 0);
        require (msg.value > highestBid);
        highestBid = msg.value;
        highestBidder = msg.sender;
        bidReturns[msg.sender] += msg.value;
    }
    
    function seeHighestBid() public view returns(uint, address){
        return (highestBid/1000000000000000000, highestBidder);
    }
    
    function hasAuctionEnded() internal view returns (bool) {
        if (block.timestamp > duration) return true;
        else return false;
    }
    
    function endAuction() public {
        require (hasAuctionEnded() == true);
        seller.transfer(highestBid); 
        bidReturns[highestBidder] -= highestBid;
        ended = true;
    }
    
    function giveMeMyMoneyBack() public {
      require (ended == true);
      msg.sender.transfer(bidReturns[msg.sender]);
    }
   
}
