// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
    call , Delagatecall (ผู้รับมอบสิทธิ์โทร)
*/

// call
contract Receiver {
    event Received(address caller, uint256 amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function foo(string memory _message, uint256 _x)
        public
        payable
        returns (uint256)
    {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }
}

contract Caller {
    event Response(bool success, bytes data);

    function testCallFoo(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 1233));

        emit Response(success, data);
    }

    function testCallDoesNotExist(address _addr) public {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}

// Delegatecall
/*
    when contract A executes the delegatecall function to the contract B. 
    => contract B execute  storage mag.sender, msg.value contract A
*/

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}

/*
        fallback() external {
            (bool result,) = address(delegate).delegatecall(msg.data);
            if (result) {
            this;
            }
        }
        await web3.utils.keccak256("pwn()")
        await contract.sendTransaction(data: "10ตัวแรกของ keccak256")
*/
