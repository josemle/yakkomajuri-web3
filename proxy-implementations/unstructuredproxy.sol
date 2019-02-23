pragma solidity^0.5.0;

contract Proxy  {
    
    
    bytes32 private constant default_location = keccak256(abi.encodePacked("location"));
    
    function initialize(address _implementation) public {
        bytes32 loc = default_location;
        assembly {
            sstore(loc, _implementation)
        }
    }
        
    function() external payable {
        bytes32 loc = default_location;
        assembly {
            let localImpl := sload(loc)
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, localImpl, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
        
        
    }
