pragma solidity ^0.4.24;

//DO NOT USE THIS CONTRACT FOR ACTUAL MESSAGE-SENDING!
//Contract made for learning purposes only
//All data is publicly visible

contract SafeMessage {

    uint messageID;
    string message;
    string password;
    string enterPassword;

function sendMessage(string _message, string _password) public {
            require (bytes(_message).length > 0 && bytes(_password).length > 0 );
            message = _message;
            password = _password;
}

function readMessage (string _enterPassword) view public returns (string) {
    require (stringsEqual(password, _enterPassword) == true);
    return (message);
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
