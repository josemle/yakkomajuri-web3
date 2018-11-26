pragma solidity^0.4.24;

contract owned {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyowner() {
        if (msg.sender == owner) {
            _;
        }
    }
}

//This contract is aimed at individuals who want to HODL but do not have the patience and discipline to do so

contract SafeHodl is owned {

    string password;
    string enterPassword;

function depositFunds(string _password) public payable { //deposit the amount of Ether to be HODLed
 require(bytes(_password).length > 0); //Set a password for extra security //WARNING: Password changes with every deposit
 require(
    msg.sender == owner,
    "You shall not pass"
); //Contract aimed for individual use only
password = _password;
}

function withdrawFunds(string _enterPassword) public { //Get your money back! Yay!
    require (msg.sender == owner);
    require (stringsEqual(password, _enterPassword) == true, //Password required to prevent people from stealing your funds by only gaining access to your address
    "Wrong password. Try again."
    ); //If you forget your password, just call depositFunds to set a new one
    require (
        (block.number >= 8000000), //Prevents you from getting back your ether before a pre-set time
        "Hold up! You wanted to HODL, didn't you? Just relax."
);
    owner.transfer((address(this)).balance); //Gives you your ether back!
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
