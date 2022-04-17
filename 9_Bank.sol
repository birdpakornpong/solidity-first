// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Bank {
    mapping(address => uint256) _balances;
    uint256 _totalSupply;

    modifier isMoreBalance(uint256 amount) {
        require(amount <= _balances[msg.sender], "not enough money");
        _;
    }

    function deposit() public payable {
        _balances[msg.sender] += msg.value;
        _totalSupply += msg.value;
    }

    function withdraw(uint256 amount) public payable isMoreBalance(amount) {
        payable(msg.sender).transfer(amount);
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
    }

    function checkBalance() public view returns (uint256 balnce) {
        return _balances[msg.sender];
    }

    function checkTotalSupply() public view returns (uint256 balanceTotal) {
        return _totalSupply;
    }
}
