//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract OnlyAdmin{

    address payable adminAddr;
    // 2 Percent For Comission
    uint comission = 50;

    constructor (){
        adminAddr = payable(msg.sender);
    }

    function getAdmin() public view returns(address){
        return adminAddr;
    }

    function isAdmin(address _target) public view returns(bool){
        return _target == adminAddr;
    }
}