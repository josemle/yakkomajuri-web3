pragma solidity^0.5.0;

contract RockPaperScissors {
    
    mapping(address => bytes32) encryptedPlay;
    mapping(bytes32 => mapping(bytes32 => uint)) payoffMatrix;
    mapping(address => bool) revealed;
    
    uint public duration = 5 hours;
    uint public price;
    uint public timeStarted;
    uint numberOfPlayers;
    
    address payable player1;
    address payable player2;
    
    bytes32 p1;
    bytes32 p2;
    
    bytes32 rock;
    bytes32 paper;
    bytes32 scissors;
    
    bool revealStarted;
    
    address payable owner;
    
    constructor() public {
        rock = sha256(abi.encodePacked("rock"));
        paper = sha256(abi.encodePacked("paper"));
        scissors = sha256(abi.encodePacked("scissors"));
        payoffMatrix[rock][rock] = 0;
        payoffMatrix[paper][paper] = 0;
        payoffMatrix[scissors][scissors] = 0;
        payoffMatrix[rock][scissors] = 1;
        payoffMatrix[scissors][paper] = 1;
        payoffMatrix[paper][rock] = 1;
        payoffMatrix[rock][paper] = 2;
        payoffMatrix[scissors][rock] = 2;
        payoffMatrix[paper][scissors] = 2;
        owner = msg.sender;
    }
    
    function enterGame(bytes32 _encryptedPlay) public payable {
        require(numberOfPlayers < 2);
        require(encryptedPlay[msg.sender] == bytes32(0));
        if (numberOfPlayers == 0) {
            price = msg.value;
            player1 = msg.sender;
        }
        else {
            require(msg.value == price);
            player2 = msg.sender;
        }
        numberOfPlayers++;
        encryptedPlay[msg.sender] = _encryptedPlay;
    }
    
    function reveal(string memory _play, string memory _nonce) public {
        require(numberOfPlayers == 2);
        require(revealed[msg.sender] == false);
        if (revealStarted == false) {
            revealStarted = true;
            timeStarted = block.timestamp;
        }
        revealed[msg.sender] == true;
        bytes32 hash = sha256(abi.encodePacked(_play, _nonce));
        bytes32 play = sha256(abi.encodePacked(_play));
        require (play == rock || play == scissors || play == rock);
        require(encryptedPlay[msg.sender] == hash);
        if (msg.sender == player1) {
            p1 = play;
        }
        else if (msg.sender == player2) {
            p2 = play;
        }
        else { revert(); }
    }


    function payOff() public {
        require(block.timestamp > timeStarted + duration);
        uint contractBalance = address(this).balance;
        if (p1 != bytes32(0) && p2 == bytes32(0)) {
            player1.transfer(contractBalance);
            reset();
        }
        else if (p2 != bytes32(0) && p1 == bytes32(0)){
            player2.transfer(contractBalance);
            reset();
        }
        else if (payoffMatrix[p1][p2] == 0) {
            player1.transfer(contractBalance/2);
            player2.transfer(contractBalance/2);
            reset();
        }
        else if (payoffMatrix[p1][p2] == 1) {
            player1.transfer(contractBalance);
            reset();
        }
        else if (payoffMatrix[p1][p2] == 2) {
            player2.transfer(contractBalance);
            reset();
        }
        else { owner.transfer(contractBalance); }
    }
    
    function refund() public {
        require(numberOfPlayers == 1);
        require(msg.sender == player1);
        player1.transfer(address(this).balance);
        reset();
    }
    
    function reset() internal {
        price = 0;
        timeStarted = 0;
        numberOfPlayers = 0;
        player1 = address(0);
        player2 = address(0);
        p1 = bytes32(0);
        p2 = bytes32(0);
        encryptedPlay[player1] = bytes32(0);
        encryptedPlay[player2] = bytes32(0);
        revealed[player1] = false;
        revealed[player2] = false;
        revealStarted = false;
    }
    
}
