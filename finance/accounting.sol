pragma solidity^0.4.25;

contract FinancialReport {
    
    uint totalrevenue;
    uint profit;
    uint totalcost;
    uint salaries;
    uint expenses;
    uint assets;
    uint wealth;
    uint datecomputed;
    
    struct Asset {
        string name;
        uint value;
        bool currentlyowned;
        uint soldfor;
        string soldto;
    }
    
    Asset[] public assetlist;
    
    mapping(string => uint) assetnames;
    mapping(address => bool) board;
    
    uint ID;
    string startdate;
    uint today;
    address chairperson;
    uint conversion;
    
    constructor(string _startdate) public {
        startdate = _startdate;
        today = block.timestamp;
        chairperson = msg.sender;
        conversion = 1000000000000000000;
    }
    
    modifier onlyboard() {
        if (msg.sender == chairperson || 
        board[msg.sender] == true) {
            _;
        }
    }
    
    function assignBoardMember(address _board) public {
        require (msg.sender == chairperson);
        board[_board] = true;
    }
    
    function depositRevenue() public payable {
        totalrevenue += msg.value;
    }
    
    function executePayment(address _to, uint _value) public onlyboard {
        uint value;
        value = _value*1000000000000000000;
        _to.transfer(value);
        expenses += value;
    }
    
    function paySalary(address _to, uint _value) public onlyboard {
        uint value;
        value = _value*1000000000000000000;
        _to.transfer(value);
        salaries += value;
    }
    
    function addAsset(string _name, uint _value) public onlyboard{
        for (uint i = 0; i < assetlist.length; i++) {
            require (stringsEqual(assetlist[i].name, _name) == false); 
        }
        uint value;
        value = _value*1000000000000000000;
        assetlist.push(Asset(_name, value, true, 0, "Not sold yet"));
        assets += value;
        assetnames[_name] = ID;
        ID++;
    }
    
    function reportSoldAsset(string _assetname, uint _value, string _soldto) 
        public 
        onlyboard {
            uint n;
            n = assetnames[_assetname];
            uint value;
            value = _value*1000000000000000000;
            assetlist[n].currentlyowned = false;
            assetlist[n].soldfor = value;
            assetlist[n].soldto = _soldto;
            assets -= assetlist[n].value; 
            totalrevenue += value;
    }
    
    function computeReport() public {
        totalcost = expenses + salaries;
        profit = totalrevenue - totalcost;
        wealth = profit + assets;
        datecomputed = (block.timestamp - today)/60/60;
    }
    
    function getReport() public view returns (
    string,
    uint,
    uint,
    uint, 
    uint,
    uint,
    uint,
    uint, 
    uint) {
        return (
            startdate,
            datecomputed,
            wealth/conversion,
            profit/conversion,
            totalrevenue/conversion,
            totalcost/conversion,
            expenses/conversion,
            salaries/conversion,
            assets/conversion);
    }
        

    function stringsEqual(string storage _a, string memory _b) 
        internal 
        pure 
        returns(bool) {
            bytes storage a = bytes(_a);
            bytes memory b = bytes(_b);
                if (keccak256(a) != keccak256(b)) {
                    return false;
                }
        return true;
    }
}
