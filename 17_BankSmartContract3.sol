// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BankSmartContract {
    mapping(address => uint256) _balances; // owner => balance
    uint256 _totalBalance;
    event Deposit(address indexed from, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    function checkTotal() public view returns (uint256 totalBalance) {
        return _totalBalance;
    }

    function checkBalanceOwner(address owner)
        public
        view
        returns (uint256 balance)
    {
        return _balances[owner];
    }

    function deposit() public payable {
        _balances[msg.sender] += msg.value;
        _totalBalance += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public payable {
        require(amount < _balances[msg.sender], "balance not enough");
        payable(msg.sender).transfer(amount);
        _balances[msg.sender] -= amount;
        _totalBalance -= amount;

        emit Withdraw(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public {
        require(amount < _balances[msg.sender], "balance not enough");
        require(to != address(0), "don't transfer to address zero");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }
}
