pragma solidity >=0.8.4;

import {ManagerUpgradeable} from "./lib.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    constructor() ERC20("test", "test") {}

    function mint(address user, uint256 amount) public {
        _mint(user, amount);
    }

    function burn(address user, uint256 amount) public {
        _burn(user, amount);
    }
}

contract Destroy is ManagerUpgradeable {
    TestToken token; //
    uint256 public rate = 2; //
    uint256 public burnTotalLeft = 2220; //
    uint256 public timelock = 150;
    uint256 public interval = 5 seconds;

    struct burnOrder {
        uint256 amount;
        uint256 timestamp;
        uint256 rewarded;
    }

    mapping(address => burnOrder[]) public burnOrderList;

    function initialize() public initializer {
        token = new TestToken();
    }

    constructor() public {
        token = new TestToken();
        token.mint(msg.sender, 1000);
        token.approve(address(this), 1000);
    }

    function t1()
        public
        view
        returns (
            address,
            uint256,
            uint256
        )
    {
        return (
            address(token),
            token.balanceOf(msg.sender),
            token.allowance(msg.sender, address(this))
        );
    }

    function burn(uint256 _amount) public {
        address user = msg.sender;
        require(
            burnTotalLeft - _amount >= 0 && token.balanceOf(user) >= _amount
        );
        burnTotalLeft = burnTotalLeft - _amount;

        burnOrder memory tmp = burnOrder(_amount, block.timestamp, 0);
        burnOrderList[user].push(tmp);

        // 销毁操作
        token.burn(user, _amount);
    }

    // 查看销毁奖励
    function rewardsCount(address _user) public view returns (uint256) {
        uint256 Orderlength = burnOrderList[_user].length;
        uint256 reward;
        for (uint256 i = 0; i < Orderlength; i++) {
            if (
                burnOrderList[_user][i].rewarded <
                burnOrderList[_user][i].amount * rate
            ) {
                uint256 burnDays = (block.timestamp -
                    burnOrderList[_user][i].timestamp) / interval;

                uint256 tmp = burnOrderList[_user][i].amount *
                    rate *
                    (burnDays / timelock) -
                    burnOrderList[_user][i].rewarded;
                reward = reward + tmp;
            }
        }
        return reward;
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
        token.mint(_user, amount * rate);
    }
}
