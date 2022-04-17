// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./safeMath.sol";

/*

*/
contract Bank {
    uint256 _balance; // state variable ประกาศตรงนี้ จะคงอยู่ตลอดไป storage ใส่ _ หน้าชื่อตัวแปลที่เป้น private
    // mapping(key, value).  type addres เป็น type ที่เก็ย address
    mapping(address => uint256) _balances;

    function depositMapping(uint256 amount) public {
        _balances[msg.sender] += amount;
    }

    function withdrawMapping(uint256 amount) public {
        _balances[msg.sender] -= amount;
    }

    function checkBalanceMapping() public view returns (uint256 balance) {
        return _balances[msg.sender];
    }

    using SafeMath for uint256;

    modifier isMoreBalance(uint256 number) {
        require(_balance > number, "withdraw must more balance");
        _;
    }

    function deposit(uint256 amount) public {
        _balance += amount;
    }

    function withdraw(uint256 amount) public isMoreBalance(amount) {
        _balance -= amount;
    }

    function withdrawSafeMath(uint256 amount) public {
        _balance = _balance.sub(amount);
    }

    function depositSafeMath(uint256 amount) public {
        _balance = _balance.add(amount);
    }

    function checkBalance() public view returns (uint256 balance) {
        return _balance;
    }
}
