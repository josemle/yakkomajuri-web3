pragma solidity ^0.4.24;

//My own interpretation of a Solidity Hello World contract

contract Hello {
    address owner;

    constructor () public {
         owner = msg.sender;
    }

    function HelloWorld () public view returns (string) {
        require (msg.sender == owner);
        return "HelloWorld";
    }
}
