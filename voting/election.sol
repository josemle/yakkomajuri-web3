pragma solidity^0.4.25;

contract Election {
    
    struct Candidate {
        address candidateaddress;
        bytes32 ID;
        string name;
        uint votes;
    }
    
    struct Voter {
        address voteraddress;
        bytes32 voterID;
        bool voted;
    }
    
    mapping(string => Candidate) name;
    mapping(address => bool) votervoted;
    mapping(address => bool) addressregistered;
    mapping(address => bool) voterregistered;

    
    Voter[] voters;
    Candidate[] public candidates;
    
    uint totalVotes;
    string candidatename;
    uint n;
    uint duration;
    address winner;
    
    
    constructor() public {
        n = 0;
        duration = block.timestamp + 2 days;
    }
    
    function registerAsCandidate(string _name, string _ID) public {
        require (addressregistered[msg.sender] == false);
        bytes32 idhash;
        idhash = keccak256(abi.encodePacked(_ID));
        for (uint i = 0; i < candidates.length; i++) {
            require (candidates[i].ID != idhash); 
        }
        candidates.push(Candidate(msg.sender, idhash, _name, 0));
        addressregistered[msg.sender] = true;
        candidatename = _name;
        name[candidatename] = candidates[n];
        n++;
    }
    
    function registerAsVoter(string _ID) public {
        require(voterregistered[msg.sender] == false);
        bytes32 idhash;
        idhash = keccak256(abi.encodePacked(_ID));
        for (uint i = 0; i < voters.length; i++) {
            require (voters[i].voterID != idhash); 
        }
        voters.push(Voter(msg.sender, idhash, false));
        voterregistered[msg.sender] = true;
    }
    
    function vote(uint _number) public {
        require (voterregistered[msg.sender] == true);
        require (votervoted[msg.sender] == false);
        votervoted[msg.sender] == true;
        candidates[_number].votes++;
        totalVotes++;
    }
    
    function endElection() public view returns (string, uint) {
        require (block.timestamp > duration);
        return (getWinner());
    }
    
        function getWinner() internal view returns (string, uint) {
        uint winnerIndex;
        uint votes;
        for(uint i = 0; i < candidates.length; i++) {
            if(candidates[i].votes > votes) {
                votes = candidates[i].votes;
                winnerIndex = i;
            }
        }
        for(i = 0; i < candidates.length; i++) {
            if(i == winnerIndex) {
                continue;
            }
            if(candidates[i].votes == votes) {
                return ("We have a draw", votes);
            }
        }
        if(votes > 0) {
            return (candidates[winnerIndex].name, votes);
        }
    }
    
}
