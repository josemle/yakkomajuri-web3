pragma solidity^0.4.24;

//Contract is a simple implementation of a simple faucet.
//Contract has a setback: users need some ether before they can get the bonus to pay for gas fees
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

contract SimpleFaucet is owned {

function depositEther () public payable {}

function giveMeSomeEther () public {
  address etherreceiver = msg.sender;
  require (etherreceiver.balance == 0);
   etherreceiver.transfer(100000000000000000);
}

function giveMeMyEtherBack () public onlyowner {  //Sends all contract ether to owner
    require (msg.sender == owner);
    owner.transfer((address(this)).balance);
}
}
