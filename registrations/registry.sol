pragma solidity^0.5.0;

// Contract still needs optimization and testing

contract RegistryStructure {
        
    modifier onlyOwners() {  // Only owners can set the price of actions
        for (uint i = 0; i < owners.length; i++) {
            require(msg.sender == creator ||
            owners[i] == msg.sender
        );
        }
        
        {
            _;
        }
    }
    
    address public creator; // Creator is the first owner, can set more
    address public current;
    
    constructor() public {
        creator = msg.sender; // Publishing address is creator
    }
    
    // Stores registered addresses
    // These addresses should ideally provide proof of ownership
    // Addresses have discount in ownership
    struct Registrant {
        string name; // Institution/Person's name
        string description; // Who you are - proof of ownership
        bool isEntity;
    }
    
    // For multi-sig documents, before the second party has signed
    // Same structure as Document struct
    struct TemporaryDocument {
        string name;
        string metadata;
        uint timestamp;
        uint16 index;
        address registrant;
        address signee;
        bytes32 hash;
        bool isEntity;
    }
    
    // Registered documents
    struct Document {
        string name;  // Name of person or document
        string metadata; // Anything 
        uint timestamp; // When was this registered 
        uint16 index; // Used in case of matching names
        address registrant; // Who registered this document
        address signee; // Second signee in multi-sig documents
        bytes32 hash;   // IPFS or file hash
        bool isEntity;  // Exists - or not
    }
    
    // Price for registering documents, updating info and registering addresses
    uint public price;  
    
    mapping(string => uint16) index; // Allows multiple registrations under same name
    mapping(bytes32 => TemporaryDocument) tempRegistry; // Temporary docs
    mapping(bytes32 => Document) registry; // Registry of docs
    mapping(address => Registrant) registered; // Is address registered
    
    TemporaryDocument[] public tempDocs;
    Document[] public documents;
    Registrant[] public registrants;
    address[] public owners; // Defines the addresses with 'onlyOwner' priviledges
}


contract DocumentRegistry is RegistryStructure {
    
    // 'creator' can set other addresses for security measures
    function safetyMeasures(address _s1, address _current) public onlyOwners {
        owners.push(_s1);
        current = _current; // Sets the address to receive payments
    }
    
    // Owners can set the prices
    function setPrice(
        uint _price
        ) 
        public 
        onlyOwners 
        {
            price = _price;
    }
    
    // Register a document - anyone is allowed to
    function registerDocument(
        string memory _name, 
        string memory _metadata,
        string memory _filehash
        ) 
        public 
        payable
        returns(
        uint16
        ){
            if(registered[msg.sender].isEntity){
                require(msg.value == price/2); // Discount for registered addresses
            }
            else {
                require(msg.value == price); // Price for registering must be paid
            }
            // Mapping names to Documents is limited
            // Mapping includes an index and a name
            uint16 id = index[_name];
            bytes32 hash = sha256(abi.encodePacked(_name, id));
            bytes32 fileHash = sha256(abi.encodePacked(_filehash));
            // No two registered hashes can be equal
            require(registry[hash].isEntity == false); 
            address(uint160(current)).transfer(msg.value); // Price paid goes to current owner
                registry[hash] = Document(
                    _name, 
                    _metadata,
                    block.timestamp, 
                    id,
                    msg.sender,
                    address(0),
                    fileHash,
                    true
                );
                /* Also pushing it to the actual array allows for external
                looping of the public array to link a user to various documents
                */
                documents.push(Document(
                    _name, 
                    _metadata,
                    block.timestamp, 
                    id,
                    msg.sender,
                    address(0),
                    fileHash,
                    true
                ));
            index[_name]++; 
            return id;
    }
    
     // Register a multi-sig document 
    function registerMultiSig(
        string memory _name, 
        string memory _metadata,
        address _address,
        string memory _filehash
        ) 
        public 
        payable
        returns(
        uint16
        ){
            if(registered[msg.sender].isEntity){
                require(msg.value == price/2); // Discount for registered addresses
            }
            else {
                require(msg.value == price); // Price for registering must be paid
            }
            // Mapping names to Documents is limited
            // Mapping includes an index and a name
            uint16 id = index[_name];
            bytes32 hash = sha256(abi.encodePacked(_name, id));
            bytes32 fileHash = sha256(abi.encodePacked(_filehash));
            // No two registered hashes can be equal
            require(registry[hash].isEntity == false); 
            address(uint160(current)).transfer(msg.value); // Price paid goes to current owner
                // If document is multi-sig, push it to the temporary registry
                tempRegistry[hash] = TemporaryDocument(
                    _name, 
                    _metadata,
                    block.timestamp, 
                    id,
                    msg.sender,
                    _address,
                    fileHash,
                    true
                    );
             /*   tempDocs.push(TemporaryDocument(
                    _name, 
                    _metadata,
                    block.timestamp,
                    _index,
                    msg.sender,
                    _address,
                    fileHash,
                    true  
                )); */
            return id;
    }
    
    
    // For multi-sig documents, second party must sign
    function signDocument(
        string memory _name, 
        uint16 _index
        ) 
        public
        returns
        (uint16)
        {
            bytes32 hashOne = sha256(abi.encodePacked(_name, _index));
            require(msg.sender == tempRegistry[hashOne].signee);
            bytes32 hashTwo = sha256(abi.encodePacked(_name, index[_name]));
                registry[hashTwo] = Document(
                    tempRegistry[hashOne].name, 
                    tempRegistry[hashOne].metadata,
                    block.timestamp, 
                    _index,
                    tempRegistry[hashOne].registrant,
                    msg.sender,
                    tempRegistry[hashOne].hash,
                    true
                );
                documents.push(Document(
                    tempRegistry[hashOne].name, 
                    tempRegistry[hashOne].metadata,
                    block.timestamp, 
                    _index,
                    tempRegistry[hashOne].registrant,
                    msg.sender,
                    tempRegistry[hashOne].hash,
                    true
                ));
            index[_name]++; 
            return index[_name];
        }
    
    // Check info for a given Document
    function checkDocument(
        string memory _name, 
        uint16 _index
        ) 
        public 
        view 
        returns(
            string memory,
            string memory,
            uint, 
            address,
            address
            )
        {
            bytes32 hash = sha256(abi.encodePacked(_name, _index));
            return (
                registry[hash].name,
                registry[hash].metadata,
                registry[hash].timestamp,
                registry[hash].registrant,
                registry[hash].signee
                );
    }
    
    // Register your address as an Institution
    function registerAddress(
        string memory _name, 
        string memory _description) 
        public
        payable
        {
            // Charge a fee to prevent spamming and fake accounts
            require(msg.value == price*10); 
            registered[msg.sender] = Registrant(
                _name, 
                _description, 
                true
                );
                registrants.push(Registrant(
                    _name, 
                    _description, 
                    true
                    ));
    }
    
    
    function whoIsThisAddress(address _address) 
        public 
        view 
        returns(
        string memory,
        string memory
        )
        {
        return(
            registered[_address].name, 
            registered[_address].description
            );
    }
    
    // Change your public info - Should we allow address changes?
    function updateMyInfo(
        string memory _name, 
        string memory _description
        )
        public
        payable
        {
            // Fee for changing details
            require(msg.value == price/10);
            require(registered[msg.sender].isEntity);
            registered[msg.sender].name = _name;
            registered[msg.sender].description = _description;
            // Old details still available for lookup on public array
            registrants.push(Registrant(
                    _name, 
                    _description, 
                    true
                    ));
        }
        
        function verifyHash(
            string memory _name, 
            uint16 _index, 
            string memory _filehash
            ) 
            public 
            view 
            returns 
            (bool) 
            {
                bytes32 hash = sha256(abi.encodePacked(_name, _index));
                bytes32 fileHash = sha256(abi.encodePacked(_filehash));
                if (registry[hash].hash == fileHash) {
                    return true;
                }
                else {
                    return false;
                }
        }
}
