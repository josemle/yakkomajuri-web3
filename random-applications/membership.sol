pragma solidity^0.4.25;

contract Membership {
    
    struct Member {
        address memberid;
        uint membershiplength;
    }
    
    Member[] members;
    
    address owner;
    
    mapping(address => bool) alreadyamember;
    mapping(address => uint) memberindex;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function buyMembership(uint _period) public payable {
        require (msg.value == _period*0.1 ether);
        require(alreadyamember[msg.sender] == false);
        uint time;
        time = block.timestamp + _period*60*60*24;
        memberindex[msg.sender] = members.length;
        members.push(Member(msg.sender, time));
        alreadyamember[msg.sender] = true;
        owner.transfer(msg.value);
    }
    
    function getMemberContent() public view returns (string) {
        for (uint i = 0; i < members.length; i++) {
            require (members[i].memberid == msg.sender); 
    }
        uint n;
        n = memberindex[msg.sender];
        require (members[n].membershiplength > block.timestamp);
    return "Member content here";
    }
}
