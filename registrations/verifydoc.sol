pragma solidity ^0.4.24;

contract CheckValidity {
    
    string hash;
    string vhash;
    
    function verify (string _hash, string _vhash) public pure returns (string) {
    require(bytes(_hash).length > 0 && bytes(_vhash).length > 0,
    "Do not leave fields blank"
    );
     require (stringsEqual(_hash, _vhash) == true,
     "Documents are not the same"
     ); 
     return "Documents match";
    }
    
        function stringsEqual(string memory _a, string memory _b) internal pure returns(bool) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);

        // Compare two strings using SHA3
        if (keccak256(a) != keccak256(b)) {
            return false;
        }
        return true;
    }
    
}
