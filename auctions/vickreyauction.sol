pragma solidity^0.4.25;

contract BlindAuction {
    
    address seller;
    uint today;
    
    modifier onlyseller() {
        if (msg.sender == seller) {
        _;
        }
    }
    
    uint highestBid;
    bytes32 highestBidOwner;
    uint auctionDuration;
    uint revealDuration;
    uint tempRevealDuration;
    bool endauction;
    bool auctionwon;
    address winner;
    bool useralreadywithdrew;
    
    mapping(bytes32 => bytes32) bids;
    mapping(bytes32 => bool) bidplaced;
    
    constructor() public {
        seller = msg.sender;
        today = block.timestamp;
        endauction = false;
        auctionwon = false;
        auctionDuration = 0;
        revealDuration = 0;
        tempRevealDuration = 0;
        highestBid = 0;
        useralreadywithdrew = false;
    }
    
    function setAuctionTime(uint _auctionDuration, uint _revealDuration) public onlyseller {
        auctionDuration = today + (_auctionDuration*60);
        tempRevealDuration = (_revealDuration*60);
    }
    
    function bid(uint _bidvalue) public {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(msg.sender));
        uint bidvalue;
        bidvalue = _bidvalue*1000000000000000000;
        require (bidplaced[hash] == false);
        require (auctionEnded() == false);
        bids[hash] = keccak256(abi.encodePacked(bidvalue, msg.sender));
        bidplaced[hash] = true;
    }
    
    function auctionEnded() internal view returns (bool) {
        if (auctionDuration < block.timestamp) return true;
        else return false;
    }
    
    function endAuction() public {
        require (auctionEnded() == true);
        require (endauction == false);
        revealDuration = block.timestamp + tempRevealDuration;
        endauction = true;
    }
    
    function revealBid() public payable {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(msg.sender));
        require (block.timestamp < revealDuration);
        require (bidplaced[hash] = true);
        require (auctionEnded() == true);
        require (keccak256(abi.encodePacked(msg.value, msg.sender)) == bids[hash]);
        require(msg.value > highestBid);
        highestBid = msg.value;
        highestBidOwner = hash;
    }
    
    function getHighestBid() public view returns (uint) {
        return (highestBid/1000000000000000000);
    }
    
    function ClaimWin() public {
        require (block.timestamp > revealDuration);
        bytes32 hash;
        hash = keccak256(abi.encodePacked(msg.sender));
        require (highestBidOwner == hash);
        seller.transfer(highestBid);
        auctionwon = true;
        winner = msg.sender;
    }
    
    function timeLeft() public view returns(string, uint) {
        uint auctiontimeleft;
        uint revealtimeleft;
        auctiontimeleft = (auctionDuration - block.timestamp)/60;
        revealtimeleft = (revealDuration - block.timestamp)/60;
        if (auctionEnded() == false) return("Auction Phase", auctiontimeleft);
        if (auctionEnded() == true) return("Reveal Phase", revealtimeleft);
    }
    
    function withdrawLostBid(uint _value) public {
        require (auctionwon == true);
        require (useralreadywithdrew == false);
        bytes32 hash;
        uint value;
        value = _value*1000000000000000000;
        hash = keccak256(abi.encodePacked(msg.sender));
        require (keccak256(abi.encodePacked(value, msg.sender)) == bids[hash]);
        msg.sender.transfer(value);
        useralreadywithdrew = true;
    }
    
    function getWinner() public view returns(address) {
        return (winner);
    }
}
