// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BFLY is ERC20 {
    constructor() ERC20("BFLY", "Polygon") {
        address company = 0xfBe639fAF55923c3136D61dC566dE469532A811a; // WALLET COMPANY แต่ใช้ wallet ส่วนตัวเนื่อง wallet company อยุ่ในช่องแชท ของการประชุมที่ถูกปิด
        _mint(msg.sender, 5 * 10**5);
        _mint(company, 5 * 10**5);
    }
}
