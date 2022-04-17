// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Election {
    // การเลือกตั้ง
    address _admin;

    struct Person {
        bool voted;
        uint256 ballots;
    }

    struct Issue {
        bool open; // default false
        mapping(address => Person) person;
        uint256[] scores;
    }

    mapping(uint256 => Issue) _issues;
    uint256 _issueId = 1;
    uint256 _max;
    uint256 _min;

    event StatusChange(uint256 indexed issueId, bool status);
    event Vote(uint256 indexed issueId, address voter, uint256 indexed number);

    constructor(uint256 min, uint256 max) {
        _admin = msg.sender;
        _min = min;
        _max = max;
    }

    modifier isAdmin() {
        require(msg.sender == _admin, "You not Admin");
        _;
    }

    function open() public isAdmin {
        require(!_issues[_issueId].open, "Election opening");

        _issueId++;
        _issues[_issueId].open = true;
        _issues[_issueId].scores = new uint256[](_max + 1);
        emit StatusChange(_issueId, true);
    }

    function close() public isAdmin {
        require(_issues[_issueId].open, "Election closed");

        _issues[_issueId].open = false;
        emit StatusChange(_issueId, false);
    }

    function vote(uint256 number) public {
        require(_issues[_issueId].open, "Election closed");
        require(number >= _min && number <= _max, "do not number you choose");
        require(!_issues[_issueId].person[msg.sender].voted, "you're voted");

        _issues[_issueId].scores[number]++;
        _issues[_issueId].person[msg.sender].voted = true;
        _issues[_issueId].person[msg.sender].ballots = number;
        emit Vote(_issueId, msg.sender, number);
    }

    function ballot() public view returns (uint256 Myvote) {
        require(
            _issues[_issueId].person[msg.sender].voted == true,
            "you must vote before check ballot"
        );
        return _issues[_issueId].person[msg.sender].ballots;
    }

    function checkStatus() public view returns (bool opening) {
        return _issues[_issueId].open;
    }

    function checkResult() public view returns (uint256[] memory result) {
        return _issues[_issueId].scores;
    }
}
