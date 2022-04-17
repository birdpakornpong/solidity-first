// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract MyContract {
    // comment
    /* declare variable
        State variable
            dataType access_modifier name;  
    */
    // accress_modifier default private
    bool status = false;
    uint256 positiveInteger = 20; // เต็มบวกเท่านั้น
    int number = 15;
    string public name = "Bird pakornpong";

    // function name(typeParam nameParam) access_modifier [pure|view|payable][returns(<return types>)]
    function store(uint256 num) public {
        positiveInteger = num;
    }

    function returnStore(uint256 num) public view returns (uint256) {
        uint256 result = positiveInteger + num;
        return result;
    }
    
    string public _name;
    uint _balance;

    constructor(string memory nameCon,uint balance) {
        require(balance > 0, "Balance must more zero");

        _name = nameCon;
        _balance = balance;
    }

    // pure function 
    function pureFunc() public pure returns (uint256 numberReturn) {
        return 50;
    }


}