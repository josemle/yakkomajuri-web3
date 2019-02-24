pragma solidity^0.5.0;

contract CertificateReg {
    
    struct Certificate {
        string name;
        string course;
        string date;
        string instructor;
    }
    
    event TellMeTheIndex (uint);
    
    uint index;
    
    mapping(uint => Certificate) certificates;
    

    function registerCert(string memory name, string memory course, string memory date, string memory instructor) public {
        certificates[index] = Certificate(name, course, date, instructor);
        index++;
        emit TellMeTheIndex(index - 1);
    }
    
    function viewCertificate(uint _index) public  view returns (string memory, string memory, string memory, string memory) {
        return (certificates[_index].name, certificates[_index].course, certificates[_index].date, certificates[_index].instructor);
    }
    
    
}
