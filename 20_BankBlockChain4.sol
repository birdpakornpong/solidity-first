// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract BankSmartContract {
    mapping(address => uint256) _balances; // owner => balance
    uint256 _totalBalance;
    event Deposit(address indexed owner, uint256 amount);
    event Transfer(address indexed owner, address indexed to, uint256 amount);
    event Withdraw(address indexed owner, uint256 amount);

    modifier isAmountMoreZero(uint256 amount) {
        require(amount > 0, "amount must more zero");
        _;
    }

    function checkTotal() public view returns (uint256 totalBalance) {
        return _totalBalance;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return _balances[owner];
    }

    function deposit() public payable isAmountMoreZero(msg.value) {
        _balances[msg.sender] += msg.value;
        _totalBalance += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public payable isAmountMoreZero(amount) {
        payable(msg.sender).transfer(amount);
        _balances[msg.sender] -= amount;
        _totalBalance -= amount;

        emit Withdraw(msg.sender, amount);
    }

    function transfer(address to, uint256 amount)
        public
        isAmountMoreZero(amount)
    {
        require(amount < _balances[msg.sender], "balance not enough");
        require(to != address(0), "don't transfer to address zero");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }
}
