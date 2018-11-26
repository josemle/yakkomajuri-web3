pragma solidity^0.4.25;

contract InvestmentPlatform {
    
    // Contract built for a hackathon - P2P investing platform
    // Needs updates - do not use in production
    
    // ADD MODIFIERS
    // ADD STATUS STATS
    // ADD stringsEqual
    // FIX dues

    struct Trader { // Defines a Trader with the following specs:
        bool isEntity; // is a registered trader
        string name; 
        string id; // same ids not allowed - DO: stringsEqual
        string idhash;
        uint reputation; 
        uint deposit;  // stake
        uint allowance; // funds allowed to manage, defined by allowance()
        uint currentbalance;
        uint minInvestment;  
        uint time;  
        uint promisedReturn; // x > 1
        uint dues;
        uint losses;
        uint wins;
        bool cantrade; // has not been prohibited from trading
    }
    
    struct TradingContract { //establishes trader-investor relationship 
        address trader;
        address investor;  
        uint value;   // value(in) - needed?
        uint expectedvalue;  // expectedvalue = value(in) * promisedReturn
        uint time;   // duration of contract
        uint status;  // 0 = std, 5 = completed
    }
    
    event OfferTaken(
        address _trader,
        address  _investor,
        uint _expectedvalue,
        uint _time
    );

    
    mapping(address => bool) investors; // is investor registered
    mapping(address => Trader) traders; // address ids trader
    mapping(address => uint) balance;  // only for traders
    mapping(bytes32 => TradingContract) contracts; // indexer for inv-trader cont
    
    Trader[] ts;
    
    function registerAsTrader(string _name, string _id, string _idhash) public payable {
        require (msg.value >= 10 ether); // minimum stake
        require (investors[msg.sender] == false &&  // trader cannot be investor 
        traders[msg.sender].isEntity == false); // trader cannot be trader 
        traders[msg.sender] = Trader(true, _name, _id, _idhash, 0, msg.value, msg.value, 0, 0, 0, 0, 0, 0, 0, true);
        balance[msg.sender] = msg.value; 
    }
    
    function depositStake() public payable {
        balance[msg.sender] += msg.value;
        traders[msg.sender].deposit += msg.value;
    }
    
    function registerAsInvestor() public { 
       require (investors[msg.sender] == false && // cannot register twice
       traders[msg.sender].isEntity == false); // cannot be trader
        investors[msg.sender] = true; // now registered
    }
    
    function submitOffer(
        uint _mininvestment, 
        uint _time, 
        uint _promisedReturn) 
        public {
            require (traders[msg.sender].isEntity); // trader exists
            traders[msg.sender].minInvestment = _mininvestment; 
            traders[msg.sender].time = _time;
            traders[msg.sender].promisedReturn = _promisedReturn;
        }
    
    function acceptOffer(address _trader) public payable { 
        require (investors[msg.sender]);
        require (traders[_trader].cantrade); //is trader allowed to trade
        //Traders cannot manage above allowance 
        require ((traders[_trader].currentbalance + msg.value) < traders[_trader].allowance); 
        require (msg.value > traders[_trader].minInvestment); // value must be higher than min
        bytes32 hash; // hash for mapping
        hash = sha256(abi.encodePacked(msg.sender, _trader)); // hash of addresses
        require (contracts[hash].trader == 0 || contracts[hash].status != 0);
        traders[_trader].currentbalance += msg.value; 
        uint expVal; //Expected value from trader at the end 
        expVal = msg.value * traders[_trader].promisedReturn/100; 
        contracts[hash] = TradingContract(_trader, msg.sender, msg.value, expVal, traders[msg.sender].time, 0);
        traders[_trader].dues += expVal; //dues are how much trader owes
        emit OfferTaken (_trader, msg.sender, expVal, traders[_trader].time);
    }
    
    function payBack(address _recipient) public payable returns(bool) { 
        bytes32 hash;
        hash = sha256(abi.encodePacked(_recipient, msg.sender));
        uint x = contracts[hash].expectedvalue - msg.value;
        require (contracts[hash].status == 0); // status hasn't been set
       // require (block.timestamp < contracts[hash].time);
        if (msg.value >= contracts[hash].expectedvalue) { 
            _recipient.transfer(msg.value);
        }
        if (msg.value < contracts[hash].expectedvalue/4) {
            _recipient.transfer(x);
            traders[msg.sender].deposit -= x;
        }
        if (2*msg.value < contracts[hash].expectedvalue) {
            _recipient.transfer(8*x/10);
            traders[msg.sender].deposit -= 8*x/10;
        }
        if (msg.value < 30*contracts[hash].expectedvalue/40) {
            _recipient.transfer(6*x/10);
            traders[msg.sender].deposit -= 6*x/10;
        }
         if (msg.value > 30*contracts[hash].expectedvalue/40
            && msg.value < contracts[hash].expectedvalue) {
            _recipient.transfer(4*x/10);
            traders[msg.sender].deposit -= 4*x/10;
        }
        traders[msg.sender].dues -= contracts[hash].expectedvalue; 
        contracts[hash].status = 1; 
        uint losses;
        losses = msg.value - contracts[hash].expectedvalue;
        traders[msg.sender].wins += msg.value;
        traders[msg.sender].losses -= losses;
        traders[msg.sender].reputation = reputation(msg.sender);
        traders[msg.sender].currentbalance -= contracts[hash].expectedvalue;
        return true;
    }
    
    function claimDefault(address _trader) public { 
        bytes32 hash;
        hash = sha256(abi.encodePacked(msg.sender, _trader));
        require(contracts[hash].time < block.timestamp); // is contract over
        require(contracts[hash].status == 0); // contract status undefined
        contracts[hash].status = 1; // DO: take out of trade's stake??
        traders[_trader].cantrade = false;
    }
    
    function withdraw(uint _value) public { //only for traders
            require (traders[msg.sender].isEntity);
            require (traders[msg.sender].dues == 0); //cannot owe to withdraw
            msg.sender.transfer(_value);
            require(balance[msg.sender] >= _value); // balance must be larger
            balance[msg.sender] -= _value;
            traders[msg.sender].deposit -= _value;
            traders[msg.sender].allowance = allowance(msg.sender);
    }
    
    // Calculate allowance based on stake and reputation
    function allowance(address _ad) internal view returns(uint) {
        uint allow;
        if (traders[_ad].reputation < 60) {
            allow = traders[_ad].deposit;
        }
        if (traders[_ad].reputation > 60) {
            allow = (100+traders[_ad].reputation)*traders[_ad].deposit/100;
        }
        return allow;
    }
    
    function getTraderInfo(address _trader) public view returns (string, string, string, uint, uint, uint, uint) {
        return (traders[_trader].name,
            traders[_trader].id,
            traders[_trader].idhash,
            traders[_trader].minInvestment,
            traders[_trader].deposit,
            traders[_trader].promisedReturn,
            traders[_trader].reputation);
    }
    
    function reputation(address _ad) internal view returns (uint) {
        uint wlRatio;
        wlRatio = traders[_ad].wins/(traders[_ad].wins + traders[_ad].losses)*100;
        uint rep;
        uint stake;
        if (traders[_ad].deposit > 100) {
            stake = 100; }
            else { 
                stake = traders[_ad].deposit; 
            }
        if (traders[_ad].deposit < 50 && wlRatio > 80) {
            stake = 110*traders[_ad].deposit/100;
        }
        rep = (wlRatio * stake)/100;
        return (rep);
    }
}
