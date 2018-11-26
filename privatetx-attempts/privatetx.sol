pragma solidity^0.4.25;

contract PrivateTx {
   
    mapping(bytes32 => uint) balance;
    
    function deposit() public payable {
        bytes32 hash;
        hash = sha256(abi.encodePacked(msg.sender));
        balance[hash] += msg.value/1000000000000000000;
    }
    
    function pay(uint _value, address _receiver) public {
        bytes32 hash;
        uint value;
        bytes32 receiver;
        hash = sha256(abi.encodePacked(msg.sender));
        value = _value;
        require (balance[hash] > value);
        balance[hash] -= value;
        receiver = sha256(abi.encodePacked(_receiver));
        balance[receiver] += value;
    }
    
    function withdraw() public {
        bytes32 hash;
        hash = sha256(abi.encodePacked(msg.sender));
        msg.sender.transfer(balance[hash]*1000000000000000000);
    }
    
    function checkMyBalance() public view returns (uint) {
        bytes32 hash;
        hash = sha256(abi.encodePacked(msg.sender));
        return (balance[hash]);
    }
    
        function withdrawToOtherAddress(address _receiver, uint _value) public {
        bytes32 hash;
        hash = sha256(abi.encodePacked(msg.sender));
        address receiver;
        receiver = _receiver;
        require (_value < balance[hash]);
        receiver.transfer(_value*1000000000000000000);
        balance[hash] -= _value;
    }
}
