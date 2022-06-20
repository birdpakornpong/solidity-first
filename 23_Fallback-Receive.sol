// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract FallbackReceive {
    /* fallback()
        auto request when 
        1 call function not have in contract
        2 send Ether with data income
        3 send Ether with empty data เข้ามาใน smart contract แล้วไม่มี receive()
    */
    address private owner;
    uint256 public number;

    constructor() {
        owner = msg.sender;
    }

    fallback() external {
        number = 2;
    }

    function foo() external {
        number = 4;
    }
}

contract Caller {
    uint256 public number;

    function call2Foo(address _contractAdd) public {
        (bool success, ) = _contractAdd.call(abi.encodeWithSignature("foo()"));

        if (success) {
            number = 4;
        } else {
            number = 2;
        }
    }

    function call2NotFunc(address _contractAdd) public {
        (bool success, ) = _contractAdd.call(
            abi.encodeWithSignature("NotFunc")
        );

        if (success) {
            number = 4;
        } else {
            number = 2;
        }
    }
}

contract ReceiveEther {
    bytes public funcName;
    uint256 public totalBalance;
    event FuncActive(string funcName);

    fallback() external payable {
        funcName = "fallback";
        emit FuncActive("fallback");
    }

    receive() external payable {
        funcName = "receive";
        emit FuncActive("receive");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function deposit() public payable {
        totalBalance += msg.value;
    }
}

contract sendEther {
    uint256 public totalBalance;
    bytes public data;

    function transferEthTo(address _to) public payable {
        payable(_to).transfer(msg.value);
    }

    function sendEthTo(address payable _to) public payable {
        bool status = _to.send(msg.value);
        if (status) {
            totalBalance -= msg.value;
        }
    }

    function callEthTo(address payable _to) public payable {
        (bool status, bytes memory dataRe) = _to.call{value: msg.value}("");
        if (status) {
            totalBalance -= msg.value;
            data = dataRe;
        }
    }

    function callEthToWith(address payable _to) public payable {
        (bool status, bytes memory dataRe) = _to.call{value: msg.value}(
            "withdata"
        );
        if (status) {
            totalBalance -= msg.value;
            data = dataRe;
        }
    }

    function deposit() public payable {
        totalBalance += msg.value;
    }
}
