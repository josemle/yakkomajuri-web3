pragma solidity^0.4.25;

contract PatientRecords {
    
    address doctor;
    
    constructor() public {
        doctor = msg.sender;
    }
    
    struct Patient {
        bytes32 name;
        bytes32 ID;
        uint weight;
        uint height;
    }

Patient[] patients;

uint indexer;

mapping(bytes32 => uint) registry;

    function registerPatient(
        string _name, 
        string _ID, 
        uint _weight, 
        uint _height) public returns (uint) {
            require (msg.sender == doctor);
            bytes32 hashone;
            bytes32 hashtwo;
            hashone = keccak256(abi.encodePacked(_name));
            hashtwo = keccak256(abi.encodePacked(_ID));
            for (uint i = 0; i < patients.length; i++) {
                    require (patients[i].ID != hashtwo);
                    require (patients[i].name != hashone);
            }        
            patients.push(Patient(
                hashone, 
                hashtwo, 
                _weight, 
                _height));
            registry[hashone] = indexer;
            indexer++;
        }
        
        function getPatientDetails(string _name)  
            public 
            view 
            returns (uint, uint) {
                require (msg.sender == doctor);
                uint n;
                n = registry[keccak256(abi.encodePacked(_name))];
                return (patients[n].height, patients[n].weight);
        }
}
