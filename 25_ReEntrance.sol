// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract modifierFunc {
    uint256 public number;
    uint256 public plusNumber;

    modifier isModifier() {
        number = 4; // ทำงานก่อน func ทำงานเสร็จ
        _;
        number = 8; // ทำงานหลัง func ทำงานเสร็จ
    }

    function plusNumberFunc() public isModifier {
        plusNumber = number + 5;
    }
}

contract EtherStore {
    //Withdrawal limit = 1 wei / week
    uint256 public constant WITHDRAWAL_LIMIT = 1 wei;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    bool locked;
    uint256 lockedGasOptimization;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    modifier noReentrantGasOptimization() {
        require(lockedGasOptimization != 1, "No re-entrancy");
        lockedGasOptimization = 1;
        _;
        lockedGasOptimization = 0;
    }

    function withdraw(uint256 _amount) public {
        // require(balances[msg.sender] >= _amount);
        // require(_amount <= WITHDRAWAL_LIMIT);
        // require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks);

        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] -= _amount;
        lastWithdrawTime[msg.sender] = block.timestamp;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function showBalance(address _addr) public view returns (uint256) {
        return balances[_addr];
    }
}

contract Attack {
    EtherStore public etherStore;
    uint256 public number;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    fallback() external {
        number = 1;
        // if (address(etherStore).balance >= 1) {
        //       etherStore.withdraw(1);
        //       number = 1;
        // }
    }

    function attDepo() external payable {
        etherStore.deposit{value: 1}();
    }

    function attWit() external {
        etherStore.withdraw(1);
    }

    function attack() external payable {
        require(msg.value >= 1);
        etherStore.deposit{value: 1}();
        etherStore.withdraw(1);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
