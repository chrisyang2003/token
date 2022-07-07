//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import {UFTToken} from "./Token.sol";

contract Destroy {
    UFTToken token;
    uint256 burnTotalLeft = 2220;

    struct burnOrder {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => burnOrder[]) public burnOrderList;

    function burn(uint256 _amount) public {
        address user = msg.sender;
        require(
            burnTotalLeft > 0 &&
                burnTotalLeft > _amount &&
                token.balanceOf(user) > _amount
        );
        burnTotalLeft = burnTotalLeft - _amount;

        burnOrder memory tmp = burnOrder(_amount, block.timestamp);
        burnOrderList[user].push(tmp);
    }

    function canClaim(address _user) public view returns (burnOrder[] memory) {
        uint256 Orderlength = burnOrderList[_user].length;

        burnOrder[] memory orderList = new burnOrder[](Orderlength);
    }
}
