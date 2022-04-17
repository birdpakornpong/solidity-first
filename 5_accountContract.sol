// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract AccountContract {
    string public _name;
    uint256 _balance;

    constructor(string memory name, uint256 balance) {
        require(balance > 0, "balance nust more zero");
        _name = name;
        _balance = balance;
    }

    function getBalance() public view returns (uint256) {
        return _balance;
    }

    function deposit(uint256 money) public {
        _balance += money;
    }
}
