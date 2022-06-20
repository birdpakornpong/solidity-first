// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BFLYVN is ERC20, AccessControl {
    bytes32 public constant VIP_ROLE = keccak256("VIP_ROLE");
    bytes32 public constant NORMAL_ROLE = keccak256("NORMAL_ROLE");

    constructor() ERC20("BFLYS", "Polygon") {
        _setupRole(VIP_ROLE, 0xbE94647CaD4bad6a93758cfAb1FD1dF0ADbe16c0); // WALLET COMPANY VIP
        _setupRole(VIP_ROLE, 0xB4268E9F789103786dFC56A983E23fd521CF8645); // WALLET VIP
        _setupRole(NORMAL_ROLE, 0x3317C3bDC600359bE1Daee5CFD5B757D85f791B4); // WALLET COMPANY NORMAL
        _setupRole(NORMAL_ROLE, 0x91120FDE3892049dAE57efCE47ef3FbF62e97b44); // WALLET NORMAL

        address company = 0xfBe639fAF55923c3136D61dC566dE469532A811a; // WALLET COMPANY แต่ใช้ wallet ส่วนตัวเนื่อง wallet company อยุ่ในช่องแชท ของการประชุมที่ถูกปิด
        _mint(msg.sender, 5 * 10**5);
        _mint(company, 5 * 10**5);
    }

    function transfer(address to, uint256 value)
        public
        override
        returns (bool success)
    {
        uint256 amount;
        uint256 amountBurn;

        if (hasRole(VIP_ROLE, msg.sender)) {
            amount = value;
        }

        if (hasRole(NORMAL_ROLE, msg.sender)) {
            amount = (value * 9) / 10;
            amountBurn = (value * 1) / 10;
        } else {
            amount = value;
        }

        _transfer(msg.sender, to, amount);
        _burn(msg.sender, amountBurn);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);

        uint256 amount;
        uint256 amountBurn;

        if (hasRole(VIP_ROLE, from)) {
            amount = value;
        }

        if (hasRole(NORMAL_ROLE, from)) {
            amount = (value * 9) / 10;
            amountBurn = (value * 1) / 10;
        } else {
            amount = value;
        }

        _burn(from, amountBurn);
        _transfer(from, to, amount);
        return true;
    }
}
