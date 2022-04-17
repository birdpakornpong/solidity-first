// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract StructureContract {
    uint256 storedData; // State variable

    function double(uint256 x) public pure returns (uint256 double_number) {
        return x * 2;
    }

    // Structs
    struct Person {
        uint256 age;
        string name;
        uint256 balance;
    }

    // Array fix และ dynamic
    uint256[2] fixArray; // fix Array

    uint256[] dynamicArray; // dynamicArray

    struct student {
        string name;
        uint256 age;
        uint256 point;
    }

    student[] public students;

    function eatHamburgers(uint256 amount)
        public
        pure
        returns (uint256 balance)
    {
        return amount;
    }

    function nameHamburger(string memory name)
        public
        pure
        returns (string memory username)
    {
        return name;
    }

    string public _name = "bird";

    function _nameHam(string memory name) private {
        _name = name;
    }

    function changeName() public {
        _nameHam("pakornpong"); // call function _nameHam
    }

    function getName() public view returns (string memory name) {
        return _name;
    }

    // event ติดต่อสื่อสารกับ frontend
    // mapping
    struct UserInfo {
        uint256 age;
        string job;
    }
    mapping(string => UserInfo) allUsers;

    function setUserInfo(
        string memory _nameInput,
        uint256 _age,
        string memory _job
    ) public {
        allUsers[_nameInput].age = _age;
        allUsers[_nameInput].job = _job;
    }

    function getuserInfo(string memory _nameGet)
        public
        view
        returns (string memory job, uint256 age)
    {
        return (allUsers[_nameGet].job, allUsers[_nameGet].age);
    }

    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function getOwner() public view returns (address addressId) {
        return owner;
    }

    function changeOwner(address newOwner) public {
        owner = newOwner;
    }

    modifier isAddressOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    function addMoney(uint256 number)
        public
        view
        isAddressOwner
        returns (uint256)
    {
        return number;
    }

    // modifier function
    modifier isMore(uint256 number) {
        require(number > 200, "number nust more 300");
        _;
    }

    function defineMoney(uint256 number)
        public
        pure
        isMore(number)
        returns (uint256)
    {
        return number;
    }

    uint256[] myArr = [1, 3, 5, 7, 9];
    bytes myBytes = "20scoops CNX";

    function checkCondition(uint256 number)
        public
        pure
        returns (string memory numberIs)
    {
        if (number % 2 == 0) {
            return "number is even";
        } else {
            return "number is odd";
        }
    }

    function sumFor() public view returns (uint256 sumResult) {
        uint256 result = 0;
        for (uint256 i = 0; i < myArr.length; i++) {
            result += myArr[i];
        }
        return result;
    }

    function sumWhile() public view returns (uint256 sumResult) {
        uint256 result = 89;
        uint256 i = 0;
        while (i < myArr.length) {
            result += myArr[i];
            i++;
        }
        return result;
    }

    function sumDowhile() public view returns (uint256 sumResult) {
        uint256 result = 876;
        uint256 i = 0;
        do {
            result += myArr[i];
            i++;
        } while (i < myArr.length);
        return result;
    }

    /*
        public:   เป็นการประกาศให้ฟังก์สามารถเข้าถึงได้ทุกที
        private:  เป็นการประกาศให้ฟังก์ชันสามารถเข้าถึงได้เฉพาะ current contract
        internal: เป็นการประกาศให้ฟังก์ชันสามารถเข้าถึงได้ current contract และ 
                contract ที่สืบทอด
        external: เป็นการประกาศให้ฟังก์ชันสามารถเข้าถึงได้ทั้ง current contract และ 
                contract ที่สืบทอดแต่ต้องมี keyword ว่า this ก่อนสำหรับการเรียกใช้
                ฟังก์ชันเช่น this.print();
        pure:    เป็นการบ่งบอกว่าฟังก์ชันนี้มีใช้งานเกี่ยวกับค่าคงที่เท่านั้นแต่ไม่มีการยุ่งเกี่ยวกับค่า
                กับค่าใน storage
        view:    เป็นการบ่งบอกว่าฟังก์ชันนี้มีการยุ่งเกี่ยวกับค่าใน storage
        payable: เป็นการบ่งบอกว่าฟังก์ชันนี้มีเรียกเก็บ ether ก่อนจะทำงานในฟังก์ชัน
        modifiers: อันนี้จะมีจะมีคำอธิบายในตัวอย่างด้านล่างนะครับ
    */

    function twoValueReturn()
        public
        pure
        returns (uint256 numA, string memory nameA)
    {
        return (45, "nantawan");
    }

    string[] fruit = ["apple", "banana", "cherry", "kiwi"];

    /*  
        function ที่มีการ return ค่าที่ยุ่งเกี่ยวกับ 
        storage ต้องใช้ keyword ว่า view
    */
    function getSizeFruit() public view returns (uint256) {
        return fruit.length;
    }
}
