pragma solidity^0.5.0;

contract Storage {
    
    modifier onlyOwners() {
        require (isOwner[msg.sender]);
        _;
    }
    

    struct TemporaryLoan {
        uint loanValue;
        uint loanTime;
        bytes32 lendee;
        bytes32 lender;
        string loanMetadata;
    }

    struct Loan {
        uint loanValue;
        uint loanTime;
        bytes32 lendee;
        bytes32 lender;
        string loanMetadata;
        bool loanPaid;
        uint totalValueRepaid;
    }
    
    struct User {
        uint timestampJoined;
        uint nLoans;
        uint nUsers;
        uint loansTotal;
        uint totalPaid;
        uint creditScore;
        uint amountGiven;
        bytes32[20] allUsers;
        bool isRegistered;
    }
    
    User[] userAccounts;
    
    mapping(bytes32 => User) public users;

    TemporaryLoan[] public temporaryLoans;
    Loan[] public loans;

    mapping(address => bool) public isOwner;
    mapping(bytes32 => uint) public allMyUsers;
    mapping(bytes32 => bool) public loanInProgress;
    mapping(bytes32 => TemporaryLoan) public tempLoans;
    mapping(bytes32 => Loan) public realLoans;
    
}

contract SmartLend is Storage {
    
    constructor(address _owner2, address _owner3) public {
        isOwner[msg.sender] = true;
        isOwner[_owner2] = true;
        isOwner[_owner3] = true;
    }

    function addUser(bytes32 _userId) public onlyOwners {
        require(users[_userId].isRegistered == false);
        users[_userId].isRegistered = true;
        users[_userId].timestampJoined = block.timestamp;
        users[_userId].loansTotal = 1;
        users[_userId].totalPaid = 1;
    }

    function requestLoan(
        uint _loanValue,
        uint _loanTime,
        uint _interest,
        bytes32 _lendee,
        bytes32 _lender,
        bytes32 _password,
        string memory _loanMetadata
        )
        public
        onlyOwners
        {
        bytes32 identifier;
        identifier = sha256(abi.encodePacked(_lendee, _lender, _password));
        require(loanInProgress[identifier] == false);
        tempLoans[identifier] =
            TemporaryLoan(
                _loanValue * _interest/100,
                _loanTime,
                _lendee,
                _lender,
                _loanMetadata
                );
    }

    function acceptLoan(bytes32 _lendee, bytes32 _lender, string memory _password) public onlyOwners {
        bytes32 password = sha256(abi.encodePacked(_password));
        bytes32 identifier;
        identifier = sha256(abi.encodePacked(_lendee, _lender, password));
        require(loanInProgress[identifier] == false);
        realLoans[identifier] = Loan(
            tempLoans[identifier].loanValue,
            block.timestamp + tempLoans[identifier].loanTime,
            tempLoans[identifier].lendee,
            tempLoans[identifier].lender,
            tempLoans[identifier].loanMetadata,
            false,
            0
            );
            loanInProgress[identifier] = true;
    }

    function getLoanInfo(
        bytes32 _lendee,
        bytes32 _lender,
        string memory _password)
        public
        view
        returns(
            uint,
            uint,
            string memory metadata)
        {
            bytes32 password = sha256(abi.encodePacked(_password));
            bytes32 identifier;
            identifier = sha256(abi.encodePacked(_lendee, _lender, password));
            metadata = realLoans[identifier].loanMetadata;
            return(
                realLoans[identifier].loanValue,
                realLoans[identifier].loanTime,
                metadata
                );
    }

    function payBackLoan(
        bytes32 _lendee, 
        bytes32 _lender, 
        string memory _password, 
        uint _value) 
        public 
        onlyOwners {
            
        bytes32 password = sha256(abi.encodePacked(_password));
        bytes32 identifier = sha256(abi.encodePacked(_lendee, _lender, password));
        if (_value == realLoans[identifier].loanValue) {
          realLoans[identifier].loanPaid = true;
        }
        else {
            realLoans[identifier].totalValueRepaid = _value;
        }
        allMyUsers[_lender]++;
        allMyUsers[_lendee]++;
        bool alreadyExists;
        for(uint i = 0; i < allMyUsers[_lender]; i++) {
            if (users[_lender].allUsers[i] == _lendee) { alreadyExists = true; }
            else { }
        }
        if (alreadyExists == false) {
            users[_lender].allUsers[allMyUsers[_lender] - 1] = _lendee;
            users[_lendee].allUsers[allMyUsers[_lendee] - 1] = _lender;
            users[_lendee].nUsers++;
            users[_lender].nUsers++;
        }
        users[_lender].nLoans++;
        users[_lendee].nLoans++;
        users[_lendee].loansTotal += realLoans[identifier].loanValue;
        users[_lendee].totalPaid += _value;
        users[_lender].creditScore = score(_lender);
        users[_lendee].creditScore = score(_lendee);
    }

    function defaultLoan(
        bytes32 _lendee, 
        bytes32 _lender, 
        string memory _password) 
        public
        onlyOwners {
        bytes32 password = sha256(abi.encodePacked(_password));
        bytes32 identifier;
        identifier = sha256(abi.encodePacked(_lendee, _lender, password));
        require(now > realLoans[identifier].loanTime && realLoans[identifier].loanPaid == false);
        realLoans[identifier].totalValueRepaid = 0;
                allMyUsers[_lender]++;
                allMyUsers[_lendee]++;
        bool alreadyExists;
        for(uint i = 0; i < allMyUsers[_lender]; i++) {
            if (users[_lender].allUsers[i] == _lendee) { alreadyExists = true; }
            else { }
        }
        if (alreadyExists == false && allMyUsers[_lender] < 20) {
            users[_lender].allUsers[allMyUsers[_lender] - 1] = _lendee;
            users[_lendee].allUsers[allMyUsers[_lendee] - 1] = _lender;
            users[_lendee].nUsers++;
            users[_lender].nUsers++;
        }
        users[_lender].nLoans++;
        users[_lendee].nLoans++;
        users[_lendee].loansTotal += realLoans[identifier].loanValue;
        users[_lender].creditScore = score(_lender);
        users[_lendee].creditScore = score(_lendee);
    }
    
    uint constant maxN = 20;
    uint constant maxLoans = 50;
    uint constant maxTime = 730 days;

    
    function score(
        bytes32 _user) 
        internal 
        view
        returns (uint) {
            uint loanPctg = uint(100*users[_user].totalPaid / users[_user].loansTotal);
            uint nUsersPctg = uint(100*users[_user].nUsers / maxN);
            uint nLoansPctg = uint(100*users[_user].nLoans / maxLoans);
            uint timePctg = uint(100*(block.timestamp - users[_user].timestampJoined) / maxTime);
            uint cScore = 100*(loanPctg*3 + nUsersPctg + nLoansPctg + timePctg/2)/ 550;
            return cScore;
    }

}
