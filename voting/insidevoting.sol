pragma solidity^0.4.25;

contract DoraVoting {

address owner;

struct Group {
    address ad;
    uint votes;
    string title;
}

uint groupid;
uint max;
uint totalvotes;
uint finalvotes;
bool voteEnded;
uint val;
    
constructor() public {
    owner = msg.sender;
    groupid = 1;
    isJudge[0xca35b7d915458ef540ade6068dfe2f44e8fa733c] = true;
    isJudge[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] = true;
}

mapping(address => bool) claimed;
mapping(address => bool) isGroup;
mapping(address => bool) isJudge;
mapping(address => bool) voted;
mapping(uint => Group) groups;
mapping(uint => uint) votes;

function setGroupLimit(uint _maxN, uint _totalvotes) public {
    require (msg.sender == owner);
    require (max == 0);
    max = _maxN;
    totalvotes = _totalvotes;
}

function registerGroup(string _title) public returns (uint) {
    require (groupid <= max);
    require (isGroup[msg.sender] == false && isJudge[msg.sender] == false);
    groups[groupid] = Group(msg.sender, 0, _title);
    isGroup[msg.sender] = true;
    groupid++;
    return (groupid-1);
}

function registerJudge(address _judge) public {
    require (msg.sender == owner);
    require (isJudge[_judge] == false);
    isJudge[_judge] = true;
}

function castVote (uint _one, uint _two, uint _three) public {
    require (voted[msg.sender] == false);
    require (_one != 0 && _two != 0 && _three != 0);
    require (_one != _two || _one != _three);
    require (_one <= max && _two <= max && _three <= max);
    require (isGroup[msg.sender] || isJudge[msg.sender]);
     groups[_one].votes++;
     groups[_two].votes++;
     groups[_three].votes++;
     voted[msg.sender] = true;
     finalvotes += 3;
}

function payWinners(bool _emergency) public payable {
    require (msg.sender == owner);
    require (finalvotes == totalvotes || 
        (_emergency == true && finalvotes > totalvotes/2));
    require (voteEnded == false);
    voteEnded = true;  
    val += msg.value;
}

function claimWinnings(uint _groupN) public {
    require(claimed[msg.sender] == false);
    require(msg.sender == groups[_groupN].ad);
        uint myshare;
        myshare = groups[_groupN].votes/finalvotes;
        msg.sender.transfer(val*myshare);
        claimed[msg.sender] = true;
}

function viewVoteStatus() public view returns(address, uint, uint) {
    uint x = 0;
    address a;
    for (uint i = 0; i < max; i++) {
        if (groups[i].votes > x) {
            x = groups[i].votes;
            a = groups[i].ad;
        }
    }
     return (a, x, finalvotes);
}

function viewVotes(uint _one) public view returns (uint) {
    return groups[_one].votes;
}

}
