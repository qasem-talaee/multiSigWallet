//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract MultiSig{

    event Deposit(address indexed Sender, uint Amount, uint Balance);

    address payable adminAddr;
    uint comission;
    address[] owners;
    struct Transaction {
        address sender;
        address payable destination;
        uint amount;
        uint confirmed;
        bool executed;
    }
    Transaction[] transactions;
    mapping (address  => bool) isOwner;
    mapping (uint => mapping (address => bool)) isConfirmed;
    bool built = false;

    modifier onlyOwner(address _from){
        require(isOwner[_from], "You are not the owner");
        _;
    }
    modifier txExist(uint _txId){
        require(_txId < transactions.length, "This transaction does not exist");
        _;
    }
    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed, "Transaction already has executed");
        _;
    }
    modifier notConfirmed(uint _txId, address _from){
        require(!isConfirmed[_txId][_from], "Transaction already confirmed by you");
        _;
    }

    constructor (address[] memory _owners, address _adminAddr, uint _comission){
        require(_owners.length > 1, "The Owners must be greater than one");
        for(uint i = 0; i<_owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0), "This address is not valid");
            require(!isOwner[owner], "This address is not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        adminAddr = payable(_adminAddr);
        comission = _comission;
        built = true;
    }

    receive() external payable{
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function getBuilt() external view returns(bool){
        return built;
    }

    function submitTransaction(address payable _to, uint _amount, address _from) external onlyOwner(_from){
        require(_to != address(0), "The Destination address is not valid");
        require(_amount < address(this).balance, "Amount must be greater than your wallet balance");
        transactions.push(
            Transaction({
                sender: _from,
                destination: _to,
                amount: _amount,
                confirmed: 0,
                executed: false
            })
        );
    }

    function confirmTransaction(uint _txId, address _from) external onlyOwner(_from) txExist(_txId) notExecuted(_txId) notConfirmed(_txId, _from){
        Transaction storage transaction = transactions[_txId];
        transaction.confirmed += 1;
        isConfirmed[_txId][_from] = true;
    }
    
    function revokeTransaction(uint _txId, address _from) external onlyOwner(_from) txExist(_txId) notExecuted(_txId){
        require(isConfirmed[_txId][_from]);
        Transaction storage transaction = transactions[_txId];
        transaction.confirmed -= 1;
        isConfirmed[_txId][_from] = false;
    }

    function executeTransaction(uint _txId, address _from) external onlyOwner(_from) txExist(_txId) notExecuted(_txId){
        Transaction storage transaction = transactions[_txId];
        require(transaction.confirmed == owners.length, "Can not execute");
        require(transaction.amount + transaction.amount/comission <= address(this).balance);
        adminAddr.transfer(transaction.amount/comission);
        transaction.destination.transfer(transaction.amount);
        transaction.executed = true;
    }

    function getOwners() external view returns(address[] memory){
        return owners;
    }

    function getTransaction(uint _txId, address _from) external view onlyOwner(_from) txExist(_txId) returns(address, address, uint, uint, bool){
        Transaction storage transaction = transactions[_txId];
        return (transaction.sender, transaction.destination, transaction.amount, transaction.confirmed, transaction.executed);
    }

    function getBalance(address _from) external view onlyOwner(_from) returns(uint){
        return address(this).balance;
    }
}