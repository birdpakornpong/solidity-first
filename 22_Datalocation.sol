// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Datalocations {
    struct MyStruct {
        uint256 foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;

    function examples() external {
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        MyStruct storage myStruct = myStructs[msg.sender];
        myStruct.text = "foo";
        // storage update ข้อมูล

        MyStruct memory readOnly = myStructs[msg.sender];
        readOnly.foo = 456;
        // memory update ข้อมูลไม่ได้
        // memory จะไม่อยุ่เก็บบน blockchain จะถุกเก็บช่วงเวลาสั้นๆ ตอนฟังชันทำงาน
    }

    function getView() external view returns (MyStruct memory) {
        return myStructs[msg.sender];
    }

    // calldata จะประหยัดค่า gas มากกว่า ในกรณี ส่งข้อมูลไปฟังชันอื่น เพราะจะไม่บันทึกลง memory
    function callDataTest(uint256[] calldata number) external {
        uint256 b; // stack variable ถูกสร้าง และหายไป เฉพาะ function ทำงาน
        myStructs[msg.sender].foo = number[0];
    }
}
