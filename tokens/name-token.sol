pragma solidity^0.4.25;

contract TestToken {
    
    modifier onlyOwner() {
        require (msg.sender == owner); {
            _;
        }
    }
    
    mapping (address => uint256) public balanceOf;
    mapping (string => address) names;
    mapping (string => uint) nameValue;

    string public name = "Test Token";
    string public symbol = "TTT";
    uint8 public decimals = 18;
    uint price;

    uint256 public totalSupply = 1000000 * (uint256(10) ** decimals);

    event Transfer(address indexed from, address indexed to, uint256 value);
    
    address owner;

    constructor() public {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
        price = 1 ether;
    }

    function setName(string _name) public payable {
        require (msg.value >= price);
        require (names[_name] == address(0));
        names[_name] = msg.sender;
        nameValue[_name] = msg.value;
    }
    
    function sellName(string _name) public {
        require (names[_name] == msg.sender);
        names[_name] = address(0);
        uint value = nameValue[_name];
        nameValue[_name] = 0;
        msg.sender.transfer(value);
    }
    
    function getAddress(string _name) public view returns (address) {
        return names[_name];
    }

    function transfer(address _to, string _name, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value);
        address to;
        if (bytes(_name).length > 0) {
            to = names[_name];
        }
        else {
            to = _to;
        }
        balanceOf[msg.sender] -= value;  
        balanceOf[to] += value;          
        emit Transfer(msg.sender, to, value);
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address _spender, string _name, uint256 value)
        public
        returns (bool success)
    {
        address spender;
        if (bytes(_name).length > 0) {
            spender = names[_name];
        }
        else {
            spender = _spender;
        }
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address _to, string _name, uint256 value)
        public
        returns (bool success)
    {
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);
        address to;
        if (bytes(_name).length > 0) {
            to = names[_name];
        }
        else {
            to = _to;
        }
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    function burnFrom(address _burned, string _name, uint _tokens) public onlyOwner {
        address burned;
        if (bytes(_name).length > 0) {
            burned = names[_name];
        }
        else {
            burned = _burned;
        }
        balanceOf[burned] -= _tokens;
    }
    
    function nameBalance(string _name) public view returns(uint) {
        return balanceOf[names[_name]];
    }
}
