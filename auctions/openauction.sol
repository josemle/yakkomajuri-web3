pragma solidity^0.5.0;

// Simple auction implementation

contract OpenAuction {
    
    address payable seller;
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
        today = block.timestamp;
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
        require (msg.value > highestBid);
        highestBid = msg.value;
        highestBidder = msg.sender;
        bidReturns[msg.sender] += msg.value;
    }
    
    function seeHighestBid() public view returns(uint, address){
        return (highestBid/1 ether, highestBidder);
    }
    
    function hasAuctionEnded() internal view returns (bool) {
        if (block.timestamp > duration) return true;
        else return false;
    }
    
    function endAuction() public {
        require (hasAuctionEnded());
        seller.transfer(highestBid); 
        bidReturns[highestBidder] -= highestBid;
        ended = true;
    }
    
    function giveMeMyMoneyBack() public {
      require (ended);
      uint money = bidReturns[msg.sender];
      bidReturns[msg.sender] = 0;
      msg.sender.transfer(money);
    }
   
}
