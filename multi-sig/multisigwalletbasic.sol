pragma solidity^0.4.25;

contract MultiSig {
    
    address one;
    address two;
    address three;
    address four;
    address five;
    
    modifier onlysignees() {
        require (msg.sender == one ||
        msg.sender == two ||
        msg.sender == three ||
        msg.sender == four ||
        msg.sender == five);
            _;
    }
    
    constructor() public {
        one = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
        two = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        three = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
        four = 0x583031d1113ad414f02576bd6afabfb302140225;
        five = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;

    }
    
    address to;
    uint value;
    uint signatures;
    mapping(address => bool) signed;
    bool proposalaccepted;
    bool proposaldropped;
    bool actionexecuted;
    bool proposalinplace;
    
    function deposit() public payable { }
    
    function submitPayment(address _to, uint _value) public onlysignees {
        require (proposalinplace == false);
        value = _value;
        to = _to;
        proposalinplace = true;
    }
    
    function signAction() public onlysignees {
        require (signed[msg.sender] == false);
        signatures++;
        signed[msg.sender] = true;
    }
    
    function closeProposal() public onlysignees {
        require (haveEnoughSigned() == true || signatures >= 3);
        if (signatures >= 3) proposalaccepted = true;
        if (signatures < 3) proposaldropped = true;
    }
    
    function executePayment() public onlysignees {
        require (proposalaccepted == true);
        to.transfer(value*1 ether);
        actionexecuted = true;
    }
    
    function haveEnoughSigned() internal view onlysignees returns (bool) {
        uint sigs;
        sigs = 0;
        if (signed[one] == true) sigs++;
        if (signed[two] == true) sigs++;
        if (signed[three] == true) sigs++;
        if (signed[four] == true) sigs++;
        if (signed[five] == true) sigs++;
        if (sigs >= 4) return true;
        else return false;
    }
    
    function proposalStatus() public view onlysignees returns (bool, bool) {
        return (proposalaccepted, haveEnoughSigned());
    }
    
    function proposal() public view onlysignees returns (address, uint) {
        return (to, value);
    }
    
    function reset() public onlysignees {
        require (proposalaccepted == true ||
        proposaldropped == true);
        require (actionexecuted == true);
        proposalaccepted = false;
        proposaldropped = false;
        actionexecuted = false;
        proposalinplace = false;
        signatures = 0;
        value = 0;
        to = 0;
        signed[one] = false;
        signed[two] = false;
        signed[three] = false;
        signed[four] = false;
        signed[five] = false;
    }
    
}
