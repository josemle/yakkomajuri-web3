contract Proxy {
    
    modifier onlyOwner() {
        address owner;
        assembly {
            owner := sload(0xfffffffffffffffffffffffffffffffffffffffe)
        }
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        address owner = msg.sender;
        assembly {
            sstore(0xfffffffffffffffffffffffffffffffffffffffe, owner)
        }
    }
    
    function setImplementation(address _implementation) public onlyOwner {
        assembly {
            sstore(0xffffffffffffffffffffffffffffffffffffffff, _implementation)
        }
    }

    function () external payable {
        address localImpl;
        assembly {
            localImpl := sload(0xffffffffffffffffffffffffffffffffffffffff)
        }
        assembly {
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
