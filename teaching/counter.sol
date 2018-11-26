pragma solidity^0.4.25;

contract CountItUp {
    
    uint count;
    
    function add() public {
        count++;
    }
    
    function subtract() public {
        count--;
    }
    
    function getCount() public view returns(uint) {
        return (count);
    }
}
