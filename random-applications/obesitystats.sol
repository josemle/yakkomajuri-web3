pragma solidity^0.4.25;

contract BMIStatistics {
    
    uint underweight;
    uint normalweight;
    uint overweight;
    uint obese;
    
    address healthagency;
    
    struct Doctor {
        address doctoraddress;
        string name;
        string id;
    }
    
    struct Patient {
        bytes32 indexer;
        uint weight;
        uint height;
        address doctor;
    }
    
    constructor() public {
        healthagency = msg.sender;
    }
    
    Doctor[] public doctors;
    Patient[] public patients;
    
    function registerDoctor(address _doctor, string _name, string _id) public {
        require (msg.sender == healthagency);
        for (uint i = 0; i < doctors.length; i++) {
            require (doctors[i].doctoraddress != _doctor); 
            require (stringsEqual(doctors[i].id, _id) == false);
    }
    doctors.push(Doctor(_doctor, _name, _id));
    }
    
    // Height must be in cm and weight in centigrams
    // For a better UX, do the conversion in the front-end
    function registerPatient(string _name, string _id, uint _weight, uint _height)
    public {
        bytes32 hash;
        hash = sha256(abi.encodePacked(_name, _id));
        for (uint i = 0; i < patients.length; i++) {
            require (patients[i].indexer != hash);
    }
     for (uint n = 0; n < doctors.length; n++) {
            require (doctors[n].doctoraddress == msg.sender);
    }
    uint bmivalue;
    bmivalue = _weight/(_height*_height);
    if (bmivalue < 185) underweight++;
    if (185 <= bmivalue && bmivalue <= 250) normalweight++;
    if (250 <= bmivalue && bmivalue <= 300) overweight++;
    if (bmivalue >= 300) obese++;
    patients.push(Patient(hash, _weight, _height, msg.sender));
    }
    
    function stringsEqual(string storage _a, string memory _b) internal pure returns(bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);
        if (keccak256(a) != keccak256(b)) {
            return false;
        }
        return true;
    }
    
    function getStats() public view returns (uint, uint, uint, uint) {
        return (underweight, normalweight, overweight, obese);
    }
}
