// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract TipJarETH {

    // The following mappings track: tip balances, tip history, who tipped
    mapping(address => uint) public tips;
    mapping(address => uint) public totalTipsReceived;
    mapping(address => address[]) public tippers;

    // add a note when sending a tip
    event TipNote(address indexed from, address indexed to, uint amount, string message);

    // tip address and view total tips
    function tip(address _recipient, string memory _message) public payable {
        require(msg.value > 0, "Must send a tip for tx to be mined");
        tips[_recipient] += msg.value;
        totalTipsReceived[_recipient] += msg.value;
        tippers[_recipient].push(msg.sender);

        emit TipNote(msg.sender, _recipient, msg.value, _message);
    }


    // withdraw tips only from address that has tips
    function withdrawTips() public {
        require(tips[msg.sender] > 0, "Must have a tip balance in order to withdraw tips");

        uint amount = tips[msg.sender];
        tips[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer has failed.");
    }

    // view the list of all tippers
    function getTippers(address _user) public view returns (address[] memory) {
        return tippers[_user];
    }

    // view total tip balance
    function getTipBalance(address _user) public view returns (uint) {
        return tips[_user];
    }

}