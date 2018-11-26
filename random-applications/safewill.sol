pragma solidity^0.4.25;

contract SafeWill {
    
    address owner;
    address firstheir;
    address secondheir;
    address thirdheir;
    address nextinline;
    uint timeframe;
    uint dday;
    uint claim;
    bool alive;
    bool fundsavailable;
    
    constructor() public {
        owner = msg.sender;
        alive = true;
        timeframe = 90 days;
    }
    
    function deposit() public payable {
        fundsavailable = true;
    }
    
    function assignHeirs(address _one, address _two, address _three) public {
        require (msg.sender == owner);
        firstheir = _one;
        secondheir = _two;
        thirdheir = _three;
        nextinline = firstheir;
    }
    
    function proofOfLife() public {
        require (msg.sender == owner);
        alive = true;
        dday = block.timestamp + timeframe;
    }
    
    function reportDeath() public {
        require (msg.sender == firstheir
         || msg.sender == secondheir
         || msg.sender == thirdheir);
         require (block.timestamp > dday);
         alive = false;
         claim = block.timestamp + timeframe;
    }
    
    function reportHeirUnavailable() public {
        require (msg.sender == firstheir
         || msg.sender == secondheir
         || msg.sender == thirdheir);
         require (block.timestamp > claim);
         require (fundsavailable == true);
         if (nextinline == firstheir) nextinline = secondheir;
         if (nextinline == secondheir) nextinline = thirdheir;
         claim = block.timestamp + timeframe;
    }
    
    function withdrawFunds() public {
         require (msg.sender == owner
         || msg.sender == firstheir
         || msg.sender == secondheir
         || msg.sender == thirdheir);
         if (msg.sender == owner) owner.transfer((address(this)).balance);
         if (alive == false) {
            require (nextinline == msg.sender); 
            nextinline.transfer((address(this)).balance); }
            fundsavailable = false;
    }
}
