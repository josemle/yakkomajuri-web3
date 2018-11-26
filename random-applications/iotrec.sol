pragma solidity^0.4.25;

contract Recycling {
    
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
    
    mapping(bytes32 => uint) weights;
    mapping(uint => address) id;
    
    uint start;
    
    constructor() public {
        id[1] = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
        id[2] = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        id[3] = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
        start = block.timestamp;
    }
    
    CpOne[] public onechecks;
    CpTwo[] public twochecks;
    CpThree[] public threechecks;
    
    
    function registerCheckOne(uint _weight) public returns (uint) {
        require (msg.sender == id[1]);
        bytes32 hash;
        hash = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        uint length;
        length = onechecks.length; 
        onechecks.push(CpOne(_weight, block.timestamp));
        weights[hash] = onechecks[length].weight;
        return (block.timestamp); 
    }
    
    function registerCheckTwo(uint _weight) public returns (uint) {
        require (msg.sender == id[2]);
        bytes32 hash;
        hash = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        uint length;
        length = twochecks.length; 
        twochecks.push(CpTwo(_weight, block.timestamp));
        weights[hash] = twochecks[length].weight;
        return (block.timestamp); 
    }
    function registerCheckThree(uint _weight) public returns (uint) {
        require (msg.sender == id[3]);
        bytes32 hash;
        hash = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        uint length;
        length = threechecks.length;
        threechecks.push(CpThree(_weight, block.timestamp));
        weights[hash] = threechecks[length].weight; 
        return (block.timestamp);
    }
    
    
    function query(uint _id, uint _timestamp) public view returns(uint) {
        require (_id <= 3 && _id > 0);
        bytes32 hash;
        hash = keccak256(abi.encodePacked(id[_id], _timestamp));
        return (weights[hash]);
    }
    
    
    function getRegistrationData() public view returns (uint, uint, uint, uint) {
        uint time;
        time = (block.timestamp - start)/60/60;
        return (onechecks.length, twochecks.length, threechecks.length, time);
    }
}
