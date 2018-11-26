pragma solidity ^0.4.24;

    
contract DocumentRegistry {
    
    struct Certificate {
        string kingsid;
        string name;
        string honors;
        string awards;
        string graduationdate;
        string hash;
        address registrantAddress;
        bool isEntity;
    }

    address kcl;
       
    constructor() public {
        kcl = msg.sender;
    }


    Certificate[] public registry;
    
    mapping(string => Certificate) certificates;

    function register(
        string _kingsid, 
        string _name, 
        string _honors, 
        string _awards, 
        string _graduationdate, 
        string _hash) public {
            require (msg.sender == kcl);
            for (uint i = 0; i < registry.length; i++) {
                require (stringsEqual(registry[i].hash, _hash) == false); 
            }
      certificates[_name] = Certificate(_kingsid, _name,  _honors,  _awards,  _graduationdate, _hash, msg.sender, true);
    }
    
     function verifyAuthenticity (string _name, string _hash) public view returns (bool) {
        if (stringsEqual(certificates[_name].hash, _hash) == true) return true;
         else return false;
    }
    
    function verifyByName(string _name) public view returns(string, 
        string, 
        string, 
        string, 
        string, 
        string) {
        require (certificates[_name].isEntity);
        return (
           certificates[_name].kingsid,
           certificates[_name].name,
           certificates[_name].honors,
           certificates[_name].awards,
           certificates[_name].graduationdate,
           certificates[_name].hash);
    }
    
    function stringsEqual(string storage _a, string memory _b) internal pure returns(bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);
        if (keccak256(a) != keccak256(b)) {
            return false;
        }
        return true;
}
    
}
