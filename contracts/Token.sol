// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.6.12;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(
            _initializing || _isConstructor() || !_initialized,
            "Initializable: contract is already initialized"
        );

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        return !Address.isContract(address(this));
    }
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context, Initializable {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function __init_owner() public initializer {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

interface IToothSwapFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function migrator() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function setMigrator(address) external;

    function pairCodeHash() external pure returns (bytes32);
}

interface IToothSwapRouter {
    function factory() external view returns (address);

    function company() external pure returns (address);

    function WHT() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityHT(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountHT,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityHT(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountHT);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityHTWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountHT);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactHTForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactHT(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForHT(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapHTForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint8 fee
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        uint8 fee
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function removeLiquidityHTSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountHT);

    function removeLiquidityHTWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountHT);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactHTForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForHTSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

abstract contract ManagerUpgradeable is Ownable {
    //Administrator Address Mapping
    mapping(address => bool) public managers;

    function __Manager_init() internal initializer {
        Ownable.__init_owner();
        address ownerAddr = owner();
        setManager(ownerAddr);
    }

    //modifier
    modifier onlyManagers() {
        require(managers[msg.sender]);
        _;
    }

    event SetManager(address _manager);
    event RemoveManager(address _manager);

    function setManager(address _manager) public onlyOwner {
        managers[_manager] = true;
        emit SetManager(_manager);
    }

    function removeManager(address _manager) public onlyOwner {
        delete managers[_manager];
        emit RemoveManager(_manager);
    }
}

/**
@dev 
- 部署之后调用setDevAddr设置基金会地址和默认邀请人地址
- 添加流动性之后，调用 setSwapPair 设置配对合约地址
- 调用 addTenAddr 设置 10 位联合创始人
- 调用 addHundredAddr 设置 100 位社区团队


- 第一年挖矿1w，每天产出28枚
- 第二年挖出2w。每天产出56枚
- 第三年挖出3w，每天产出87枚
- 每年递增1w，一直挖到100w停止

- 流动性挖矿收益扣除15%，5%销毁，10%直接转入底池
- 交易间转账直接扣除 5% ，2%销毁，3%进入底池子
- 交易to地址是pair地址，扣除10%，2%销毁，8%进入底池子

- 设置路由合约为白名单，并且设置不分红属性:0xBba6D427D10d87E29AB1a537F4338E227F5728D4
 */
contract UFTToken is IERC20, ManagerUpgradeable {
    using SafeMath for uint256;
    using Address for address;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    // 邀请信息
    mapping(address => address) public inviter;
    address public _fundAddr;
    address public _inviteFeeAddr;
    address[] public _lpAddr;
    mapping(address => uint256) _lpAddrIndexes;
    mapping(address => bool) _lpAddrExist;
    address[] public _tenAddr;
    mapping(address => uint256) _tenAddrIndexes;
    address[] public _hundredAddr;
    mapping(address => uint256) _hundredAddrIndexes;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _tTotal;
    IToothSwapRouter public swapRouter;
    address public swapPair;

    mapping(address => bool) public notBonus;
    mapping(address => bool) public whiteList;
    uint256 public burnTotal;
    address public chefPool;
    address[] public blacklist;
    mapping(address => uint256) public blacklistIndexes;
    mapping(address => bool) public userBlackList;

    address public chefPool2;

    function initialize() public initializer {
        _name = "SPE Token";
        _symbol = "SPE";
        _decimals = 18;
        swapRouter = IToothSwapRouter(
            0xBba6D427D10d87E29AB1a537F4338E227F5728D4
        );
        // _tTotal = 10000 * 10**_decimals;
        _tOwned[msg.sender] = _tTotal;
        _fundAddr = msg.sender;
        _inviteFeeAddr = msg.sender;
        whiteList[msg.sender] = true;
        __Manager_init();
        emit Transfer(address(0), msg.sender, _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function burn(address to, uint256 amount) public {
        _burn(to, amount);
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        // require(amount > 0, "Transfer amount must be greater than zero");
        _transferStandard(from, to, amount);
    }

    function mint(address _to, uint256 _amount) public onlyManagers {
        _mint(_to, _amount);
    }

    function _burn(address account, uint256 amount) private {
        require(account != address(0), "ERC20: burn from the zero address");
        _tOwned[account] = _tOwned[account].sub(amount);
        _tTotal = _tTotal.sub(amount);
        burnTotal = burnTotal.add(amount);
        emit Transfer(account, address(0), amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _tTotal = _tTotal.add(amount);
        _tOwned[account] = _tOwned[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    // 获取邀请列表
    function getInviterList(address _user) public returns (address[] memory) {
        address[] memory inviterList = new address[](10);
        address tmp = _user;
        for (uint256 i = 0; i < 10; i++) {
            if (inviter[tmp] != address(0)) {
                tmp = inviter[tmp];
                inviterList[i] = tmp;
            } else {
                inviterList[i] = address(0);
            }
        }
        return inviterList;
    }

    function _transferStandard(
        address from,
        address to,
        uint256 amount
    ) private {
        require(!userBlackList[from], "blacklist");
        _tOwned[from] = _tOwned[from].sub(amount);
        uint256 useFee = 0;

        bool shouldSetInviter = balanceOf(to) == 0 &&
            inviter[from] == address(0) &&
            !Address.isContract(from);
        if (shouldSetInviter) {
            inviter[from] = to;
        }

        if (swapPair != address(0) && !notBonus[from]) {
            if (to == swapPair) {
                useFee = 10;
                _takeburnFee(from, amount, 2);
                _takeLPFee(from, amount, 8);
            }
        }
        if (
            from != swapPair &&
            from != address(swapRouter) &&
            from != address(0) &&
            from != address(this) &&
            swapPair != address(0)
        ) {
            setlpAddr(from);
        }
        if (
            to != swapPair &&
            to != address(swapRouter) &&
            to != address(0) &&
            to != address(this) &&
            swapPair != address(0)
        ) {
            setlpAddr(to);
        }

        //如果不在白名单，扣除手续费
        if (
            !whiteList[from] &&
            swapPair != address(0) &&
            !whiteList[to] &&
            !Address.isContract(from) &&
            !Address.isContract(to)
        ) {
            useFee = useFee.add(5);
            // _tOwned[swapPair] = _tOwned[swapPair].add(amount.mul(3).div(100));
            // emit Transfer(from, swapPair, amount.mul(3).div(100));

            _takeLPFee(from, amount, 3);
            _takeburnFee(from, amount, 2);

            // burn(from, amount.mul(2).div(100));
        }

        uint256 recipientRate = 100 - useFee;
        _tOwned[to] = _tOwned[to].add(amount.mul(recipientRate).div(100));
        emit Transfer(from, to, amount.mul(recipientRate).div(100));
    }

    /**
    @dev 燃烧之后，总供应量要减少
     */
    function _takeburnFee(
        address sender,
        uint256 amount,
        uint256 fee
    ) private {
        if (fee == 0) return;
        uint256 burnAmount = amount.div(100).mul(fee);
        _tOwned[address(0)] = _tOwned[address(0)].add(burnAmount);
        // todo
        _tTotal = _tTotal.sub(burnAmount);
        emit Transfer(sender, address(0), burnAmount);
    }

    function _takeLPFee(
        address sender,
        uint256 amount,
        uint256 fee
    ) private {
        if (fee == 0) return;
        uint256 lpAmount = amount.div(100).mul(fee);
        _takeInviterFee(sender, lpAmount, 10);
        _takeFundFee(sender, lpAmount, 10);
        _takeTenFee(sender, lpAmount, 10);
        _takeHundredFee(sender, lpAmount, 10);
        _takeAddLpFee(sender, lpAmount, 60);
    }

    function _takeInviterFee(
        address sender,
        uint256 amount,
        uint256 fee
    ) private {
        address paddr = inviter[sender];
        if (paddr == address(0)) {
            paddr = _inviteFeeAddr;
        }
        uint256 takeAmount = amount.div(100).mul(fee);
        _tOwned[paddr] = _tOwned[paddr].add(takeAmount);
        emit Transfer(sender, paddr, takeAmount);
    }

    function _takeFundFee(
        address sender,
        uint256 amount,
        uint256 fee
    ) private {
        uint256 takeAmount = amount.div(100).mul(fee);
        _tOwned[_fundAddr] = _tOwned[_fundAddr].add(takeAmount);
        emit Transfer(sender, _fundAddr, takeAmount);
    }

    function _takeTenFee(
        address sender,
        uint256 amount,
        uint256 fee
    ) private {
        if (_tenAddr.length == 0) {
            return;
        }
        uint256 avgAmount = amount.div(100).mul(fee).div(_tenAddr.length);
        for (uint256 i = 0; i < _tenAddr.length; i++) {
            _tOwned[_tenAddr[i]] = _tOwned[_tenAddr[i]].add(avgAmount);
            emit Transfer(sender, _tenAddr[i], avgAmount);
        }
    }

    function _takeHundredFee(
        address sender,
        uint256 amount,
        uint256 fee
    ) private {
        if (_hundredAddr.length == 0) {
            return;
        }
        uint256 avgAmount = amount.div(100).mul(fee).div(_hundredAddr.length);
        for (uint256 i = 0; i < _hundredAddr.length; i++) {
            _tOwned[_hundredAddr[i]] = _tOwned[_hundredAddr[i]].add(avgAmount);
            emit Transfer(sender, _hundredAddr[i], avgAmount);
        }
    }

    function _takeAddLpFee(
        address sender,
        uint256 amount,
        uint256 fee
    ) private {
        uint256 _lpAddrCount = _lpAddr.length;
        if (_lpAddrCount == 0) {
            return;
        }
        uint256 takeAmount = amount.div(100).mul(fee);
        uint256 totalLpSupply = IERC20(swapPair).totalSupply();
        if (chefPool != address(0)) {
            totalLpSupply = totalLpSupply.sub(
                IERC20(swapPair).balanceOf(chefPool)
            );
        }
        if (chefPool2 != address(0)) {
            totalLpSupply = totalLpSupply.sub(
                IERC20(swapPair).balanceOf(chefPool2)
            );
        }
        for (uint256 i = 0; i < _lpAddrCount; i++) {
            if ((_lpAddr[i] != chefPool) && (_lpAddr[i] != chefPool2)) {
                uint256 currAmount = takeAmount
                    .mul(IERC20(swapPair).balanceOf(_lpAddr[i]))
                    .div(totalLpSupply);
                _distributeLp(sender, _lpAddr[i], currAmount);
            }
        }
    }

    function _distributeLp(
        address sender,
        address lpAddr,
        uint256 amount
    ) internal {
        _tOwned[lpAddr] = _tOwned[lpAddr].add(amount);
        emit Transfer(sender, lpAddr, amount);
    }

    function setlpAddr(address lpAddr) private {
        if (swapPair == address(0)) {
            return;
        }
        if (lpAddr == chefPool) {
            return;
        }
        if (_lpAddrExist[lpAddr]) {
            if (IERC20(swapPair).balanceOf(lpAddr) == 0) quitlpAddr(lpAddr);
            return;
        }
        if (IERC20(swapPair).balanceOf(lpAddr) == 0) return;
        addlpAddr(lpAddr);
        _lpAddrExist[lpAddr] = true;
    }

    function addlpAddr(address lpAddr) internal {
        _lpAddrIndexes[lpAddr] = _lpAddr.length;
        _lpAddr.push(lpAddr);
    }

    function quitlpAddr(address lpAddr) private {
        removelpAddr(lpAddr);
        _lpAddrExist[lpAddr] = false;
    }

    function removelpAddr(address lpAddr) internal {
        _lpAddr[_lpAddrIndexes[lpAddr]] = _lpAddr[_lpAddr.length - 1];
        _lpAddrIndexes[_lpAddr[_lpAddr.length - 1]] = _lpAddrIndexes[lpAddr];
        _lpAddr.pop();
    }

    function addTenAddr(address[] memory addr) public onlyManagers {
        for (uint256 i = 0; i < addr.length; i++) {
            if (addr[i] == address(0)) {
                continue;
            }
            _tenAddrIndexes[addr[i]] = _tenAddr.length;
            _tenAddr.push(addr[i]);
        }
    }

    function removeTenAddr(address[] memory addr) public onlyManagers {
        for (uint256 i = 0; i < addr.length; i++) {
            if (addr[i] == address(0)) {
                continue;
            }
            _tenAddr[_tenAddrIndexes[addr[i]]] = _tenAddr[_tenAddr.length - 1];
            _tenAddrIndexes[_tenAddr[_tenAddr.length - 1]] = _tenAddrIndexes[
                addr[i]
            ];
            _tenAddr.pop();
        }
    }

    function addHundredAddr(address[] memory addr) public onlyManagers {
        for (uint256 i = 0; i < addr.length; i++) {
            if (addr[i] == address(0)) {
                continue;
            }
            _hundredAddrIndexes[addr[i]] = _hundredAddr.length;
            _hundredAddr.push(addr[i]);
        }
    }

    function removeHundredAddr(address[] memory addr) public onlyManagers {
        for (uint256 i = 0; i < addr.length; i++) {
            if (addr[i] == address(0)) {
                continue;
            }
            _hundredAddr[_hundredAddrIndexes[addr[i]]] = _hundredAddr[
                _hundredAddr.length - 1
            ];
            _hundredAddrIndexes[
                _hundredAddr[_hundredAddr.length - 1]
            ] = _hundredAddrIndexes[addr[i]];
            _hundredAddr.pop();
        }
    }

    function setDevAddr(address fundAddr, address inviteFeeAddr)
        public
        onlyManagers
    {
        require(
            fundAddr != address(0) && inviteFeeAddr != address(0),
            "can not input zero address"
        );
        _fundAddr = fundAddr;
        _inviteFeeAddr = inviteFeeAddr;
    }

    function setSwapPair(address addr) public onlyManagers {
        swapPair = addr;
    }

    function setNotBonus(address addr, bool isBonus) public onlyManagers {
        notBonus[addr] = isBonus;
    }

    function setWhiteList(address addr, bool isWhite) public onlyManagers {
        whiteList[addr] = isWhite;
    }

    function setInitBurnTotal(uint256 amount) public onlyManagers {
        burnTotal = amount;
    }

    function setChef(address chef) public onlyManagers {
        chefPool = chef;
    }

    function setChef2(address chef) public onlyManagers {
        chefPool2 = chef;
    }

    function addBlacklist(address[] memory addr) public onlyManagers {
        for (uint256 i = 0; i < addr.length; i++) {
            if (addr[i] == address(0)) {
                continue;
            }
            userBlackList[addr[i]] = true;
        }
    }

    function removeBlacklist(address[] memory addr) public onlyManagers {
        for (uint256 i = 0; i < addr.length; i++) {
            if (addr[i] == address(0)) {
                continue;
            }
            userBlackList[addr[i]] = false;
        }
    }

    function getTenAddrIndexes(address user) public view returns (uint256) {
        return _tenAddrIndexes[user];
    }

    function getHundredAddrIndexes(address user) public view returns (uint256) {
        return _hundredAddrIndexes[user];
    }

    function getLpAddrExist(address user) public view returns (bool) {
        return _lpAddrExist[user];
    }

    function getHundredAddr() public view returns (address[] memory) {
        return _hundredAddr;
    }

    function getTenAddr() public view returns (address[] memory) {
        return _tenAddr;
    }
}
