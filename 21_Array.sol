// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Array {
    // storage arrays
    uint256[] public myArray; // crud create,read,update,delete

    function foo() external {
        myArray.push(2);
        myArray.push(4);
        myArray[1] = 5;
        myArray.push(6);
        myArray.push(7);
        delete myArray[3];
    }

    // memory Array
    // memoryArray push ไม่ได้
    function bar() external {
        uint256[] memory myArrayM = new uint256[](10);
        // myArrayM.push(1);
        myArrayM[0] = 1;
        myArrayM[1] = 8;
        myArrayM[2] = 9;
        myArrayM[0] = 10;
        delete myArrayM[2];
        myArray = myArrayM; // ทำให้ myArray เป็น memory ไปด้วย
    }

    function viewArray() public view returns (uint256[] memory) {
        return myArray;
    }

    /* storage memory ต่างกัน 1 memory array อยู่ชั่วคราว 
    2 memory array ไม่สามารกเป็น dynamic Array
    3 memory array not push
    */
    function foobar(uint256[] calldata myArg)
        external
        pure
        returns (uint256[] calldata)
    {
        return myArg;
        // external calldata ได้ แต่ถ้าเป็น public internal ต้องใช้ memory
    }
}
