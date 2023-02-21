
//Total Requirements
// 
// 1. Admin will deposit gold tokens from the treasury wallet and set 
//    the gold price at discounted rate than its in the market. 
//    May be 5 to 10% discount when needed

// 2. Time limit. The discount will only be available for set time.
//    Admin set the time for the discounted rate usin frontend on the contract.

// 3. When they timer ends, sales will be off.

// 4. Users will buy $GLD token using ETH.

// 5. ETH will be sent to the GLD token owner wallet.

// 6. Must be able to connect metamask wallet connect and ledger hadware wallets for trade.

// 7. Interest calculation based on shared table schedule , if someone claims their tokens, 
//    it will reset to level 1

// 8. Admin has the ability to kick wallet out of staking , this is if someone deposit gold, but 
//    forgot or lost their wallet address, we don't want money keep going into that account, 
//    we want the admint to kick the vallet out from staking, at the time it will send the use his earnings automatically 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Goldswap {
    using SafeMath for uint256;

    address payable admin;

    uint256 ratio;  
    uint256 fees;
    IERC20 public Gold;
    uint256 discountRate;  
    uint256 expiry;
    address[] public blacklist;

    constructor(address _gold, uint256 _ratio) {
        admin = payable(msg.sender);
        ratio = _ratio;
        Gold = IERC20(_gold);
        discountRate = 0;
        expiry = 0;
    }

    modifier onlyAdmin() {
        require(payable(msg.sender) == admin, "Caller is not Admin");
        _;
    }

    function setRatio(uint256 _ratio) public onlyAdmin{
        ratio = _ratio;
    }

    function getRatio() public view returns (uint256){
        return ratio;
    }

    function setFees(uint256 _Fees) public onlyAdmin {
        fees = _Fees;
    }

    function getFees() public view returns (uint256) {
        return fees;
    }

    function ETHtoGolds() public returns (uint256) {


        require(msg.value > 0, "ETHamount must be greater than zero");

        uint256 ETHamount = msg.value;

        uint256 exchangeA = ETHamount.mul(ratio);
        
        if (block.timestamp < expiry) {
            exchangeA = exchangeA.mul(10000 + discountRate);
        }
        uint256 exchangeAmount = exchangeA;
        require(exchangeAmount > 0, "exchange Amount must be greater then Zero");

        require(Gold.balanceof(address(this)) > exchangeAmount,
        "currently the exchange doesnt have enough Gold tokens, Please retry later :=(");

        payable(admin).transfer(msg.value);
        Golds.transfer(
            address(msg.sender),
            exchangeAmount
        );
        return exchangeAmount;
    }

    function createDiscount(uint256 rate, uint256 time) public onlyAdmin {
        discountRate = rate;
        expiry = block.timestamp + time;
    }
   
}