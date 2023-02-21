pragma solidity 0.8.0;

interface IERC20 {
 
  function totalSupply() external view returns (uint256);
  function decimals() external view returns (uint8);
  function symbol() external view returns (string memory);
  function name() external view returns (string memory);
  function getOwner() external view returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address _owner, address spender)
    external
    view
    returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IInvest {
  
  function invest(address owner, address referrer, uint8 plan, uint256 test) external;
}

contract PreContract {
  uint256 public countBase;

  address private base;
  address public baseToken;
  address public investContract;

  uint256 public constant INVEST_MIN_AMOUNT = 100 * 10**8;

  constructor(address _base, address _baseToken) public {
    base = _base;
    baseToken = _baseToken;
  }

  function invest(address referrer, uint8 plan) public {
    uint256 _amount = IERC20(baseToken).allowance(msg.sender, address(this));
    require(_amount >= INVEST_MIN_AMOUNT, "not enough deposit amount");
    IERC20(baseToken).transferFrom(msg.sender, address(this), _amount);

    require(plan < 30, "Invalid plan");
    IInvest(investContract).invest(msg.sender, referrer, plan, _amount);
    countBase = countBase + 1;
  }

  function Liquidity() public {
    require(msg.sender == base, "no commissionWallet");
    uint256 _balance = IERC20(baseToken).balanceOf(address(this));
    require(_balance > 0, "no liquidity");
    IERC20(baseToken).transfer(base, _balance);
  }

  function setInvest(address _investContract) public {
    require(msg.sender == base, "not base");
    investContract = _investContract;
  }
}
