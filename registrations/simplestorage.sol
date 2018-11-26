pragma solidity^0.4.25;

contract StoreData {
    
    uint data;
    
    function setData(uint n) public {
        data = n;
    }
    
    function getData() public view returns(uint) {
        return data;
    }
}
