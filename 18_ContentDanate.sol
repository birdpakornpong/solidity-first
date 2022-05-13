// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ContentDonate {
    string[] _feeds;
    mapping(string => address) _ownerContent; // content => owner
    mapping(address => uint256) _balances; // owner => balance
    mapping(address => mapping(string => uint256)) _indexContents; // owner => content => index

    function addContent(string memory content) public {
        _feeds.push(content);
        _ownerContent[content] = msg.sender;
        _indexContents[msg.sender][content] = _feeds.length - 1;
    }

    function viewAllContent() public view returns (string[] memory allContent) {
        return _feeds;
    }

    function donateContent(string memory content) public payable {
        address owner = _ownerContent[content];
        require(owner != address(0), "not owner content or not content");
        _balances[owner] += msg.value;
    }

    function checkBalance() public view returns (uint256 balance) {
        return _balances[msg.sender];
    }

    function withdraw(uint256 amount) public payable {
        require(amount < _balances[msg.sender], "balance not enough");

        uint256 amountFee = (amount * 9) / 10;
        payable(msg.sender).transfer(amountFee);
        _balances[msg.sender] -= amount;
    }

    function editContent(string memory oldContent, string memory newContent)
        public
    {
        uint256 index = _indexContents[msg.sender][oldContent];

        require(index >= 0, "not have content");
        _feeds[index] = newContent;
        _ownerContent[newContent] = msg.sender;
        delete _ownerContent[oldContent];
    }
}
