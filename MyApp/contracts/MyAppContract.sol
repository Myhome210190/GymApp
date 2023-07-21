// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GymMembership is ERC20 {
    struct Member {
        bool isMember;
        uint256 lastClaimed;
    }

    mapping(address => Member) public members;
    address public admin;

    constructor(address _token) ERC20("GymMembershipToken", "GMT") {
        admin = msg.sender;
    }

    function buyMembership() external {
        require(members[msg.sender].isMember == false, "Already a member");
        _mint(msg.sender, 10);
        members[msg.sender] = Member(true, block.timestamp);
    }

    function claimTokens() external {
        require(members[msg.sender].isMember == true, "Not a member");
        require(block.timestamp > members[msg.sender].lastClaimed + 30 days, "Already claimed this month");
        _mint(msg.sender, 5);
        members[msg.sender].lastClaimed = block.timestamp;
    }

    function cancelMembership() external {
        require(members[msg.sender].isMember == true, "Not a member");
        members[msg.sender].isMember = false;
    }
}