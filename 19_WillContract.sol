// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract WillContract {
    address _admin;
    uint256 _balance;
    uint256 _balanceFee;
    struct Heir {
        address heir;
        uint256 amount;
    }
    mapping(address => Heir) _wills;
    event Create(address owner, address heir, uint256 amount);
    event Transfer(address from, address to, uint256 amount);

    constructor() {
        _admin = msg.sender;
    }

    modifier isAdmin() {
        require(msg.sender == _admin, "you not admin");
        _;
    }

    function checkBalanceFee() public view isAdmin returns (uint256 balance) {
        return _balanceFee;
    }

    function checkBalance() public view returns (uint256 balance) {
        return _balance;
    }

    function createWill(address heir) public payable {
        require(heir != address(0), "not address zero");
        require(msg.value > 0, "money must more 0");

        uint256 amountDisFee = (msg.value * 95) / 100;
        _wills[msg.sender].heir = heir;
        _wills[msg.sender].amount = amountDisFee;
        _balance += amountDisFee;
        _balanceFee += (msg.value - amountDisFee);

        emit Create(msg.sender, heir, msg.value);
    }

    function tranfer(address owner) public payable isAdmin {
        require(owner != address(0), "address not zero");

        uint256 amount = _wills[owner].amount;
        address heir = _wills[owner].heir;
        uint256 amountDisFee = (amount * 97) / 100;
        payable(heir).transfer(amountDisFee);
        _balance -= amount;
        _balanceFee += (amount - amountDisFee);
        delete _wills[owner];

        emit Transfer(owner, heir, amountDisFee);
    }

    function checkWill(address owner)
        public
        view
        isAdmin
        returns (address heir, uint256 amount)
    {
        require(owner != address(0), "owner not address zero");

        return (_wills[owner].heir, _wills[owner].amount);
    }
}
