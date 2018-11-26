pragma solidity^0.4.25;

contract PrivateTxs {
    
    mapping(bytes32 => uint) balances;
    mapping(bytes32 => uint) pendingtx;
    mapping(bytes32 => bool) accountopen;

    function deposit(string _password) public payable {
        bytes32 hash;
        hash = (sha256(abi.encodePacked(msg.sender, _password)));
        balances[hash] += msg.value;
        accountopen[hash] = true;
    }
    
    function executeTransaction(
        string _password, 
        address _receiver, 
        uint _value)  
        public {
            bytes32 hash;
            hash = sha256(abi.encodePacked(msg.sender, _password));
            require (accountopen[hash] == true);
            require (balances[hash] > _value);
            bytes32 x;
            x = (sha256(abi.encodePacked(msg.sender, _receiver)));
            balances[hash] -= _value;
            pendingtx[x] += _value;
    }
    
    function acceptTx(address _sender, string _password) public {
        bytes32 hash;
        hash = sha256(abi.encodePacked(_sender, msg.sender));
        bytes32 x;
        x = sha256(abi.encodePacked(msg.sender, _password));
        balances[x] += pendingtx[hash];
        pendingtx[hash] -= pendingtx[hash];
    }
    
    function checkMyBalance(string _password) public view returns (uint) {
        bytes32 hash;
        hash = sha256(abi.encodePacked(msg.sender, _password));
        return (balances[hash]);
    }
    
    function withdraw(uint _amount, string _password, address _receiver) public {
        bytes32 hash;
        hash = sha256(abi.encodePacked(msg.sender, _password));
        require (balances[hash] > _amount);
        _receiver.transfer(_amount);
        balances[hash] -= _amount;
    }
    
}
