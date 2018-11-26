pragma solidity^0.4.25;


// Use as reference for implementing logs
contract Logs {
    
    function getLog() public payable {
        log1(
            bytes32(msg.sender),
            bytes32(msg.value)
            );
    }
}
