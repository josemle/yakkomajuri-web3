pragma solidity^0.4.25;

contract Password {
    
    bytes32 password;
    bool passwordset;
    address owner;
    
    constructor() public {
        passwordset = false;
        owner = msg.sender;
    }
    
    function HelloWorld(string _password) public view returns (string) {
        bytes32 attempt;
        attempt = keccak256(abi.encodePacked(_password));
        require (attempt == password);
        return "Hello World!";
    }
    
    function setPassword(string _password) public {
        require (passwordset == false);
        password = keccak256(abi.encodePacked(_password));
        passwordset = true;
    }
    
    function resetPassword(string _currentpassword, string _newpassword) public {
        require (password == keccak256(abi.encodePacked(_currentpassword)));
        require (owner == msg.sender);
        password = keccak256(abi.encodePacked(_newpassword));
    }
}
