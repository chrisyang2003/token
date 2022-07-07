pragma solidity >=0.6.12;

import {Token, SafeMath} from "./Token.sol";

contract Destroy {
    Token token;
    uint256 burnTotalLeft = 2220;
    uint256 timelock = 150;

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

        // 销毁操作
        token.transferFrom(user, address(0), _amount);
    }

    function canClaim(address _user) public view returns (burnOrder[] memory) {
        uint256 Orderlength = burnOrderList[_user].length;

        burnOrder[] memory list = new burnOrder[](Orderlength);

        for (uint256 i = 0; i < Orderlength; i++) {
            if (
                burnOrderList[_user][i].timestamp + timelock * 1 days >
                block.timestamp
            ) {
                list[i] = burnOrderList[_user][i];
            }
        }
        return list;
    }

    function claim() public {
        address _user = msg.sender;
        uint256 Orderlength = burnOrderList[_user].length;
        uint256 amount;
        for (uint256 i = 0; i < Orderlength; i++) {
            if (
                burnOrderList[_user][i].timestamp + timelock * 1 days >
                block.timestamp
            ) {
                amount = amount + burnOrderList[_user][i].amount;
            }
        }
        token.mint(_user, amount * 2);
    }
}
