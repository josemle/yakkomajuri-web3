pragma solidity ^0.4.24;

    
contract DocumentRegistry {
    
    struct Document {
        string registrantid;
        string registrantname;
        string firstandsecondparty;
        string scope;
        string expirydate;
        string hash;
        address registrantAddress;
    }
    
    
    uint ID;
    
       
    constructor() public {
        ID = 0;

    }


    Document[] public documents;
  
 

    function register(string _registrantname, string _registrantid, string _firstandsecondparty, string _scope, string _expirydate, string _hash) public returns (bool, uint){
        require(bytes(_registrantname).length > 0 && bytes(_registrantid).length > 0);
         require(bytes(_firstandsecondparty).length > 0);
          require(bytes(_registrantname).length > 0 && bytes(_registrantid).length > 0);
        for (uint i = 0; i < documents.length; i++) {
             require (stringsEqual(documents[i].hash, _hash) == false); 
        }
      ID++;
       documents.push(Document(_registrantid, _registrantname,  _firstandsecondparty,  _scope,  _expirydate, _hash, msg.sender));
       return (true, ID);
    }
    
     function verify (uint _indexer, string _hash) public view returns (bool) {
         if (stringsEqual(documents[_indexer].hash, _hash) == true) return true;
         else return false;
    }
    
    function stringsEqual(string storage _a, string memory _b) internal pure returns(bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);

        // Compare two strings using SHA3
        if (keccak256(a) != keccak256(b)) {
            return false;
        }
        return true;
}
    
}
