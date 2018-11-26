pragma solidity^0.4.25;

contract IntellectualProperty {
    
    struct OwnershipRegistration {
        string name;
        string description;
        bytes32 documentation;
        uint dateregistered;
        address registrant;
        address owner;
    }
    
    OwnershipRegistration[] public registrations;
    
    uint ID;
    address owner;
    
    mapping(string => uint) names;
    mapping(string => bool) forsale;
    mapping(string => uint) price;
    mapping(string => address) buyer;
    mapping(string => address) seller;

    constructor() public {
        owner = msg.sender;
    }
    
    function register(
        string _name, 
        string _description,
        string _documentation) 
        public payable {
            require (msg.value == 0.1 ether);
            owner.transfer(msg.value);
            bytes32 hash;
            hash = keccak256(abi.encodePacked(_documentation));
            for (uint i = 0; i < registrations.length; i++) {
            require (stringsEqual(registrations[i].name, _name) == false);
            require (stringsEqual(registrations[i].description, _description) == false);
            require (registrations[i].documentation != hash);
        }
        registrations.push(OwnershipRegistration(
            _name, _description, hash, block.timestamp, msg.sender, msg.sender));
            names[_name] = ID;
            ID++;
    }
    
    function transferOwnership(string _name, address _buyer, uint _price) public payable {
        uint n;
        n = names[_name];
         require (forsale[_name] == false && registrations[n].owner == msg.sender); 
            forsale[_name] = true;
            price[_name] = _price*1000000000000000000;
            buyer[_name] = _buyer;
    }
    
    function payForOwnership(string _name) public payable {
        uint n;
        n = names[_name];
        require (forsale[_name] == true && msg.sender == buyer[_name]);
        require (msg.value == price[_name]);
        forsale[_name] == true && msg.sender == buyer[_name];
        forsale[_name] = false;
        buyer[_name] = 0;
        seller[_name] = registrations[n].owner;
        registrations[n].owner = msg.sender;
        seller[_name].transfer(msg.value);
        seller[_name] = 0;
        price[_name] = 0;
    }
    
    function registrationSearch(string _name) public view returns (
        string,
        string,
        bytes32,
        uint,
        address,
        address) {
             uint n;
             n = names[_name];
            return (
               registrations[n].name, 
               registrations[n].description,
               registrations[n].documentation,
               registrations[n].dateregistered,
               registrations[n].registrant,
               registrations[n].owner);
        }
    
        function stringsEqual(string storage _a, string memory _b) 
        internal 
        pure 
        returns(bool) {
            bytes storage a = bytes(_a);
            bytes memory b = bytes(_b);
                if (keccak256(a) != keccak256(b)) {
                    return false;
                }
        return true;
    }
    
}
