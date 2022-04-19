// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IHello {
    function hello(uint a, uint b) external returns (uint);
    function world() external;
}

contract Hello {
    function getInterfaceId() public pure returns (bytes4) {
        return type(IHello).interfaceId;
    }
    function getSelector() public pure returns (bytes4) {
        return IHello.hello.selector ^ IHello.world.selector;
    }
    function getKaccak() public pure returns (bytes4) {
        return bytes4(keccak256("hello(uint256,uint256)") ^ bytes4(keccak256("world()"))); 
        //keccak ใน hello uint256 ถ้าเว้นวรรคก็ไม่ตรง
    }

    function getLength(address addr) public view returns(uint) {
        return addr.code.length; // contract length ไม่ใช่ 0
    }
}