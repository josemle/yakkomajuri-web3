pragma solidity^0.4.25;

contract SimpleCoin {

    address owner;

constructor() public {
    owner = msg.sender;
}

    modifier onlyowner() {
        if (msg.sender == owner) {
         _;
        }
    }

    uint totalSupply;
    
    mapping (address => uint) public balances;
    
    function mintNewCoins(uint _n) public onlyowner {
        balances[msg.sender] += _n;
        totalSupply += _n;
    }
    
    function getBalance(address _a) public view returns (uint) {
        return balances[_a];
    }
    
    function getTotalSupply() public view returns (uint){
        return totalSupply;
    }
    
    function transferCoins(address _receiver, uint _value) public {
        require (balances[msg.sender] > _value);
        balances[msg.sender] -= _value;
        balances[_receiver] += _value;
    }
}
