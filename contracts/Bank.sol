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

    function response() external pure returns (string memory) {
        return "hello";
    }

    function getbalance() external view returns (uint256) {
        return userAccounts[tx.origin].balance;
    }

    function deposit() public payable {
        if (userAccounts[tx.origin].part_in) revert("can only interest once");
        userAccounts[tx.origin].balance += msg.value;
        userAccounts[tx.origin].part_in = !userAccounts[tx.origin].part_in;
    }

    function withdraw(uint256 amount) public payable {
        if (userAccounts[tx.origin].balance < amount)
            revert("not enought money");
        payable(tx.origin).transfer(amount);
        userAccounts[tx.origin].balance -= amount;
    }
}
