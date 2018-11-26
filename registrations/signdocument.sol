pragma solidity^0.4.25;

contract SignDocument {
    
    struct Document {
        string hash;
        address partyone;
        address partytwo;
    }
    
    constructor() public {
        waityourturn = 0;
    }
    
    string prehash;
    address signer;
    address submitter;
    uint waityourturn;
    uint today;
    
    Document[] public documents;
    
    function registerDocument(string _prehash, address _signer) public {
        if (timeExpired() == true) waityourturn = 0;
        require(waityourturn == 0);
        prehash = _prehash;
        submitter = msg.sender;
        signer = _signer;
        today = block.timestamp;
        waityourturn++;
    }
    
    function signDocument() public {
        require(msg.sender == signer);
        require(waityourturn == 1);
        waityourturn = 0;
        documents.push(Document(prehash, submitter, signer));
    }
    
    function documentInfo() public view returns (string) {
        require(waityourturn == 1);
        return (prehash);
    }
    
    function timeExpired() internal view returns (bool) {
        if (block.timestamp >= today + 6 hours) return true; 
        else return false;
    }
    
}
