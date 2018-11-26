pragma solidity^0.4.25;

contract TestNFT {
    
    mapping(uint => address) owner;
    mapping(uint => uint) characterPrice;
    
    uint maxNumber = 100;
    uint currentNumber = 1;
    
    struct Character {
        string name;
        uint features;
        uint value;
        uint16 level;
        bool rare;
        bool forSale;
    }
    
    Character[] public characters;
    
    constructor() public {
        characters.push(Character("Boss", 300000, 0, 65535, true, false));
    }
    
    function createCharacter(
            string _name, 
            uint _features
            ) 
            public 
            payable {
                require (msg.value >= 1 ether);
                require (currentNumber < maxNumber);
                bool rare;
                    if (random() == 255) {
                        rare = true;
                    }
                    else {
                        rare = false;
                    }
                owner[currentNumber] = msg.sender;
                characters.push(
                    Character(
                        _name, 
                        _features, 
                        msg.value, 
                        0, 
                        rare,
                        false
                    ));
                currentNumber++;
    }
    
        function random()  
            internal 
            view 
            returns 
            (uint8) 
            {
            return uint8(
                uint256(
                    keccak256(abi.encodePacked(
                        block.timestamp, 
                        block.difficulty)))
                        % 256);
    }
    
    function transferOwnership(uint _id, address _to) public {
        owner[_id] = _to;
    }
    
    function CharacterForSale(uint _id, uint _value) public {
        if (characters[_id].forSale) {
            characters[_id].forSale = false;
        }
        else {
            characters[_id].forSale = true;
            characterPrice[_id] = _value;
        }
    }
    
    function buyCharacter(uint _id) public payable {
        require(characters[_id].forSale);
        require(characterPrice[_id] == msg.value);
        owner[_id] = msg.sender;
    }
    
    
}
