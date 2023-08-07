// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MuscleMint is ERC20 {
    struct Member {
        bool isMember;
        uint256 lastClaimed;
        uint256 joinTimestamp;
        uint256 expireTimestamp;
    }

    mapping(address => Member) public members;
    mapping(uint256 => uint256) public itemPrices;
    address public admin;

    constructor() ERC20("MuscleMint", "MM") {
        admin = msg.sender;
    }

    function setItemPrice(uint256 itemId, uint256 price) external {
        require(msg.sender == admin, "Only admin can set prices");
        itemPrices[itemId] = price;
    }

    function buyMembership() external payable {
        require(members[msg.sender].isMember == false, "Already a member");
        require(msg.value >= 0.05 ether, "Membership costs 0'05 Ether"); 
       
        if (members[msg.sender].joinTimestamp == 0) {
            // This is the first time the user buys a membership
            _mint(msg.sender, 10);
            members[msg.sender] = Member(true, block.timestamp, block.timestamp,  block.timestamp + 60);
        } else if (block.timestamp > members[msg.sender].expireTimestamp) {
            // User's previous membership has expired, and they are renewing it
            _mint(msg.sender, 3);
            members[msg.sender] = Member(true, members[msg.sender].lastClaimed, block.timestamp,  block.timestamp + 60);
        }
        
    }

    function claimTokens() external {
        require(members[msg.sender].isMember == true, "Not a member");
        require(block.timestamp > members[msg.sender].lastClaimed + 30 days, "Already claimed in the last 60 days");
        _mint(msg.sender, 5);
        members[msg.sender].lastClaimed = block.timestamp;
    }

    function buyItem(uint256 itemId) external {
        require(members[msg.sender].isMember == true, "Not a member");
        uint256 price = itemPrices[itemId];
        require(balanceOf(msg.sender) >= price, "Not enough tokens to buy this item");
        _transfer(msg.sender, admin, price);
        // Add code here to record that the item was bought, or trigger an event.
    }

    function cancelMembership() external {
        require(members[msg.sender].isMember == true, "Not a member");
        members[msg.sender].isMember = false;  
    }
}
