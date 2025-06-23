// License 
// SPDX-License-Identifier: MIT

// Solidity compiler version
pragma solidity 0.8.24;

// Libraries
import "./interfaces/IV2Router02.sol";
import "./interfaces/IFactory.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

// Contract
contract swapApp {

    using SafeERC20 for IERC20;

    // Variables
    address public V2Router02Address;
    address public UniswapFactoryAddress;
    address public USDT;
    address public DAI;
    uint256 public lpTokenAmount2;

    // Events
    event e_swapTokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event e_addLiquidity(address token0, address token1, uint256 lpTokenAmount);

    // Constructor
    constructor(address V2Router02Address_, address UniswapFactoryAddress_, address USDT_, address DAI_){
        V2Router02Address = V2Router02Address_;
        UniswapFactoryAddress = UniswapFactoryAddress_;
        USDT = USDT_;
        DAI = DAI_;
    }

    function swapTokens(uint256 amountIn_, uint256 amountOutMin_, address[] memory path_, address to_, uint256 deadline_) public returns(uint256) {
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        IERC20(path_[0]).approve(V2Router02Address, amountIn_);
        uint256[] memory amountOuts = IV2Router02(V2Router02Address).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, to_, deadline_);
        emit e_swapTokens(path_[0], path_[path_.length - 1], amountIn_, amountOuts[amountOuts.length - 1]);
        return amountOuts[amountOuts.length - 1];
    }

    function addLiquidity(uint256 amountIn_, uint256 amountOutMin_, address[] memory path_, uint256 amountAMin_, uint256 amountBMin_, uint256 deadline_) external {
        IERC20(USDT).safeTransferFrom(msg.sender, address(this), amountIn_/2); 
        uint256 swappedAmount = swapTokens(amountIn_/2, amountOutMin_, path_, address(this), deadline_);
        IERC20(USDT).approve(V2Router02Address, amountIn_/2);
        IERC20(DAI).approve(V2Router02Address, swappedAmount);
        (,,uint256 lpTokenAmount) = IV2Router02(V2Router02Address).addLiquidity(USDT, DAI, amountIn_/2, swappedAmount, amountAMin_, amountBMin_, msg.sender, deadline_);
        lpTokenAmount2 = lpTokenAmount;
        emit e_addLiquidity(USDT, DAI, lpTokenAmount);
    }

    function removeLiquidity(address lpTokenAddress_, uint256 liquidityAmount_, uint256 amountAMin_, uint256 amountBMin_, address to_, uint256 deadline_) external{
        IERC20(lpTokenAddress_).safeTransferFrom(msg.sender, address(this), liquidityAmount_);
        IERC20(lpTokenAddress_).approve(V2Router02Address, liquidityAmount_);
        IV2Router02(V2Router02Address).removeLiquidity(USDT, DAI, liquidityAmount_, amountAMin_, amountBMin_, to_, deadline_);
    }

}