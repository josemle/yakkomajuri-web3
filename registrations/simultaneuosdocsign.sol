pragma solidity^0.4.25;

contract SignDocument {
    
    struct Document {
        string hash;
        address partyone;
        address partytwo;
    }
    
    struct Temporarydoc {
        string temphash;
        address temppartyone;
        address temppartytwo;
    }
    
    
    uint indexer;
    uint id;
    uint tempid;
    string prehash;
    address signer;
    address submitter;
    
    constructor() public {
        id = 0;
        tempid = 0;
    }
    
    Document[] public documents;
    Temporarydoc[] public temporarydocs;
    
    function registerDocument(string _prehash, address _signer) public returns (uint) {
    submitter = msg.sender;
    temporarydocs.push(Temporarydoc(_prehash, submitter, _signer));
    tempid++;
    return(tempid);
    }
    
    function signDocument(uint _indexer) public returns (uint) {
        indexer = _indexer;
        require (temporarydocs[indexer].temppartytwo == msg.sender);
        documents.push(Document(temporarydocs[indexer].temphash, temporarydocs[indexer].temppartyone, temporarydocs[indexer].temppartytwo));
        id++;
        return(id);
    }
    
}
