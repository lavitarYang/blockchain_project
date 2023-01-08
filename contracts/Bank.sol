// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public admin;
    mapping(address => storageUnit) public userAccounts;
    struct storageUnit {
        uint256 balance;
        bool part_in;
    }
    constructor() {
        admin = msg.sender;
    }
    function getbalance() external view returns (uint256) {
        return userAccounts[msg.sender].balance;
    }
    function deposit() public payable {
        if (userAccounts[msg.sender].part_in) revert("can only interest once");
        userAccounts[msg.sender].balance += msg.value;
        userAccounts[msg.sender].part_in = !userAccounts[msg.sender].part_in;
    }

    function withdraw(uint256 amount) public payable {
        if (userAccounts[msg.sender].balance < amount)
            revert("not enought money");
        payable(msg.sender).transfer(amount);
        userAccounts[msg.sender].balance -= amount;
    }
}
