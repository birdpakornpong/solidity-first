// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract bankBirth {
    mapping(address => uint256) _balance;
    uint256 _totalTransaction;

    modifier isMoreBalance(uint256 amount) {
        require(_balance[msg.sender] > amount, "amount must be less balance");
        _;
    }

    function deposit() public payable {
        _balance[msg.sender] += msg.value;
        _totalTransaction += msg.value;
    }

    function withdraw(uint256 amount) public payable isMoreBalance(amount) {
        payable(msg.sender).transfer(amount);
        _balance[msg.sender] -= amount;
        _totalTransaction -= amount;
    }

    function checkBalance() public view returns (uint256 balance) {
        return _balance[msg.sender];
    }

    function checkTotal() public view returns (uint256 totalTransaction) {
        return _totalTransaction;
    }
}
