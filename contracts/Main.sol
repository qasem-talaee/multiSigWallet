//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./contracts/MultiSig.sol";
import "./contracts/Admin.sol";

contract Main is OnlyAdmin{

    struct multisigIndex{
        uint index;
        bool exist;
    }
    mapping (string => multisigIndex) public multisigMap;
    MultiSig[] multisigs;

    modifier sigExist(string memory _pass) {
        require(multisigMap[_pass].exist, "MultiSig wallet does not exist");
        _;
    }

    function checkPassword(string memory _pass) public pure returns(bool){
        uint len = bytes(_pass).length;
        return len >= 8;
    }

    function addMultiSig(string memory _pass, address[] memory _owners) public {
        require(checkPassword(_pass), "Password must be greater than 8");
        require(!multisigMap[_pass].exist, "The password is already exist");
        MultiSig thisMulti = new MultiSig(_owners, adminAddr, comission);
        require(thisMulti.getBuilt(), "The MultiSig Wallet doesn't create for some reason");
        multisigMap[_pass].index = multisigs.length;
        multisigMap[_pass].exist = true;
        multisigs.push(thisMulti);
    }

    function submitTransaction(string memory _pass, address payable _to, uint _amount) public sigExist(_pass){
        multisigs[multisigMap[_pass].index].submitTransaction(_to, _amount, msg.sender);
    }

    function confirmTransaction(string memory _pass, uint _txId) public sigExist(_pass){
        multisigs[multisigMap[_pass].index].confirmTransaction(_txId, msg.sender);
    }

    function revokeTransaction(string memory _pass, uint _txId) public sigExist(_pass){
        multisigs[multisigMap[_pass].index].revokeTransaction(_txId, msg.sender);
    }

    function executeTransaction(string memory _pass, uint _txId) public sigExist(_pass){
        multisigs[multisigMap[_pass].index].executeTransaction(_txId, msg.sender);
    }

    function getOwners(string memory _pass) public view sigExist(_pass) returns(address[] memory){
        return multisigs[multisigMap[_pass].index].getOwners();
    }

    function getTransaction(string memory _pass, uint _txId) public view sigExist(_pass) returns(address, address, uint, uint, bool){
        return multisigs[multisigMap[_pass].index].getTransaction(_txId, msg.sender);
    }

    function getBalance(string memory _pass) public view sigExist(_pass) returns(uint){
        return multisigs[multisigMap[_pass].index].getBalance(msg.sender);
    }

    function getAddress(string memory _pass) public view sigExist(_pass) returns(address){
        return address(multisigs[multisigMap[_pass].index]);
    }

    function chargeWallet(string memory _pass) public payable sigExist(_pass) {
        require(msg.value > 0, "You must send ether");
        address payable target = payable(address(multisigs[multisigMap[_pass].index]));
        target.transfer(msg.value);
    }
}