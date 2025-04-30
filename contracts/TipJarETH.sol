// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract TipJarETH {

    // track tip balances
    mapping(address => uint) public tips;

    function tip(address _recipient) public payable {
        require(msg.value > 0, "Must send a tip for tx to be mined");
        tips[_recipient] += msg.value;
    }

    function withdrawTips() public {
        require(tips[msg.sender] > 0, "Must have a tip balance in order to withdraw tips");

        uint amount = tips[msg.sender];
        tips[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer has failed.");
    }

}