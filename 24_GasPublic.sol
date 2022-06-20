// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GasPublicExternal {
    string private typeN;

    function publicTestFunc() public {
        typeN = "public";
    }

    function externalTestFunc() external {
        typeN = "external";
    }

    // public ไว้ใช้ ไม่เสียค่า gas
    function getType() public view returns (string memory) {
        return typeN;
    }
}

contract CallerGas is GasPublicExternal {
    function callPublic() external {
        // 50389
        publicTestFunc();
    }

    function callExternal() external {
        //33922
        this.externalTestFunc();
    }
}

contract BytesOrStrings {
    string constant _string = "cryptopus.co Medium";
    bytes32 constant _bytes = "cryptopus.co Medium";

    function getAsString() public pure returns (string memory) {
        return _string;
    }

    function getAsBytes() public pure returns (bytes32) {
        return _bytes;
    }

    function bytes32ToString(bytes32 _bytes32)
        public
        pure
        returns (string memory)
    {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
}
