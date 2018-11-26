pragma solidity^0.4.25;

contract Recycling {
    
    uint txidone;
    uint txidtwo;
    uint txidthree;
    
    mapping(uint => address) uniqueID;

    struct CpOne {
        uint weight;
        uint timestamp;
    }
    
    struct CpTwo {
       uint weight;
       uint timestamp;
    }
    
    struct CpThree {
        uint weight;
        uint timestamp;
    }
    
    constructor() public {
        uniqueID[1] = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        uniqueID[2] = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
        uniqueID[3] = 0x583031d1113ad414f02576bd6afabfb302140225;
    }
    
    CpOne[] public pointone;
    CpTwo[] public pointtwo;
    CpThree[] public pointthree;
    
    function registerWeight(uint _weight) public returns (uint, uint) {
        require (msg.sender == uniqueID[1] || 
            msg.sender == uniqueID[2] ||
            msg.sender == uniqueID[3]);
        if (msg.sender == uniqueID[1]) 
        (pointone.push(CpOne(_weight, block.timestamp)),
        txidone++);  
        if (msg.sender == uniqueID[1]) return (txidone, block.timestamp);
        if (msg.sender == uniqueID[2]) 
        (pointtwo.push(CpTwo(_weight, block.timestamp)),
        txidtwo++); 
         if (msg.sender == uniqueID[2]) return (txidtwo, block.timestamp);
        if (msg.sender == uniqueID[3]) 
        (pointthree.push(CpThree(_weight, block.timestamp)),
        txidthree++); 
         if (msg.sender == uniqueID[3]) return (txidthree, block.timestamp);
    }
    
    function getWeight(uint _uniqueid, uint _txid) public view returns (uint) {
        if (_uniqueid == 1) return (pointone[_txid].weight);
        if (_uniqueid == 2) return (pointtwo[_txid].weight);
        if (_uniqueid == 3) return (pointthree[_txid].weight);
    }
    
    function getAddresses() public view returns (address, address, address) {
        return (uniqueID[1], uniqueID[2], uniqueID[3]);
    }
}
