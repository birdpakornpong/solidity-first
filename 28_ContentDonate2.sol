// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ContentDonate {
    string[] public _feeds;
    mapping(string => address) _ownerContent; // content => owner
    mapping(address => uint256) _balances; // owner => balance
    mapping(address => mapping(string => uint256)) _indexContents; // owner => content => index
    address _owner;

    constructor() {
        _owner = msg.sender;
    }

    function addContent(string memory content) external {
        _feeds.push(content);
        _ownerContent[content] = msg.sender;
        _indexContents[msg.sender][content] = _feeds.length - 1;
    }

    function donateContent(string memory content) external payable {
        address owner = _ownerContent[content];
        require(owner != address(0), "not owner content or not content");
        _balances[owner] += msg.value;
    }

    function checkBalance() public view returns (uint256 balance) {
        return _balances[msg.sender];
    }

    function withdraw(uint256 amount) external payable {
        require(amount <= _balances[msg.sender], "balance not enough");

        uint256 amountFee = (amount * 95) / 100;
        uint256 fee = (amount * 5) / 100;

        (bool status, ) = payable(msg.sender).call{value: amountFee}("");
        require(status, "tranfer not complete");

        _balances[msg.sender] -= amount;
        _balances[_owner] += fee;
    }

    function editContent(string memory oldContent, string memory newContent)
        external
    {
        uint256 index = _indexContents[msg.sender][oldContent];

        require(index >= 0, "not have content");
        _feeds[index] = newContent;
        _ownerContent[newContent] = msg.sender;
        delete _ownerContent[oldContent];
    }
}
