pragma solidity^0.4.25;

contract EtherPoints {
    
    struct Invoice {
        address payee;
        address payer;
        uint amount;
        bool paid;
    }
    
    
    Invoice[] invoices;
    
    uint invoiceNr;
    uint conversion;
    address owner;

    mapping(address => uint) moneybalance;
    mapping(address => uint) rewardbalance;
    
    event InvoiceSubmitted(address payee, address payer, uint amount, bool paid);
    event InvoicePaid(address payee, address payer, uint amount, bool paid);
    event RewardPaid(address rewarded, uint points);
    
    
    constructor() public {
        conversion = 12000000000000000000;
        invoiceNr = 0;
        moneybalance[msg.sender] += 1000000;
    }

    function pay(address _receiver) public payable {
        _receiver.transfer(msg.value);
        rewardbalance[msg.sender] += msg.value/conversion;
        emit RewardPaid(msg.sender, msg.value/conversion);
    }
    
    function payWithPoints(address _receiver, uint _amount) public {
        require (rewardbalance[msg.sender] > _amount);
        rewardbalance[msg.sender] -= _amount;
        rewardbalance[_receiver] += _amount;
    }
    
    function submitInvoice(address _payer, uint _amount) public returns(uint) {
        invoices.push(Invoice(msg.sender, _payer, _amount, false));
        return (invoiceNr);
        invoiceNr++;
        emit InvoiceSubmitted(msg.sender, _payer, _amount, false);
    }
    
    function payInvoice(uint _invoiceNumber) public payable{
        require (msg.value/1000000000000000000 == invoices[_invoiceNumber].amount);
        rewardbalance[msg.sender] += msg.value/conversion;
        invoices[_invoiceNumber].paid = true;
        emit InvoicePaid(invoices[_invoiceNumber].payee, msg.sender, msg.value, true);
        emit RewardPaid(msg.sender, msg.value/conversion);
    }
    
    function hasInvoiceBeenPaid(uint _invoiceNumber) public view returns (string) {
        if (invoices[_invoiceNumber].paid == true) return "This invoice has been paid";
        else return "This invoice has not been paid yet";
    }
    
    function checkBalances() public view returns (uint, uint) {
        return (moneybalance[msg.sender], rewardbalance[msg.sender]);
        }
}
