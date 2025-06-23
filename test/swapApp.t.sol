// License 
// SPDX-License-Identifier: MIT

// Solidity compiler version
pragma solidity 0.8.24;

// Libraries
import "forge-std/Test.sol";
import "../src/swapApp.sol";

// Contract
contract swapAppTest is Test{

    swapApp app;

    // Variables
    address uniswapV2SwapRouterAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24;
    address UniswapFactoryAddress = 0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9;
    address user = 0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX; // Address with USDC in Arbitrum Mainnet
    address tokenUSDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831; // USDC address in Arbitrum Mainnet
    address tokenDAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI address in Arbitrum Mainnet
    address lpTokenAddress; // Liquidity Provideer Tokens of de Liquidity Pool

    // Set Up
    function setUp() public{
        app = new swapApp(uniswapV2SwapRouterAddress, UniswapFactoryAddress, tokenUSDC, tokenDAI);
    }

    // Testing functions

    function testHasBeenDeployedCorrectly() public view {
        assert(app.V2Router02Address() == uniswapV2SwapRouterAddress);
    }

    function testSwapTokensCorrectly() public {
        vm.startPrank(user);
        uint256 amountIn = 6 * 1e6;
        uint256 amountOutMin = 0 * 1e18;
        IERC20(tokenUSDC).approve(address(app), amountIn);
        uint256 deadline = 1750495124 + 100000000000;
        address[] memory path = new address[](2);
        path[0] = tokenUSDC; 
        path[1] = tokenDAI;
        uint256 usdcBalanceBefore = IERC20(tokenUSDC).balanceOf(user);
        uint256 daiBalanceBefore = IERC20(tokenDAI).balanceOf(user);
        app.swapTokens(amountIn, amountOutMin, path, user, deadline);
        uint256 usdcBalanceAfter = IERC20(tokenUSDC).balanceOf(user);
        uint256 daiBalanceAfter = IERC20(tokenDAI).balanceOf(user);
        assert(usdcBalanceAfter == usdcBalanceBefore - amountIn);
        assert(daiBalanceAfter > daiBalanceBefore);
        vm.stopPrank();
    }

    function testCanAddLiquidityCorrectly() public{
        vm.startPrank(user);
        uint256 amountIn_ = 6 * 1e6;
        uint256 amountOutMin_ = 0 * 1e18;
        address[] memory path_ = new address[](2);
        path_[0] = tokenUSDC; 
        path_[1] = tokenDAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = 1750495124 + 100000000000;
        IERC20(tokenUSDC).approve(address(app), amountIn_);
        app.addLiquidity(amountIn_, amountOutMin_, path_, amountAMin_, amountBMin_, deadline_);
        vm.stopPrank();
    }

    function testCanRemoveLiquidityCorrectly() public{
        vm.startPrank(user);

        uint256 amountIn_ = 6 * 1e6;
        uint256 amountOutMin_ = 0 * 1e18;
        address[] memory path_ = new address[](2);
        path_[0] = tokenUSDC; 
        path_[1] = tokenDAI;
        uint256 amountAMin_ = 0;
        uint256 amountBMin_ = 0;
        uint256 deadline_ = 1750495124 + 100000000000;
        IERC20(tokenUSDC).approve(address(app), amountIn_);
        app.addLiquidity(amountIn_, amountOutMin_, path_, amountAMin_, amountBMin_, deadline_);
     
        uint256 liquidityAmount = app.lpTokenAmount2();
        uint256 amountAMin = 2 * 1e6;
        uint256 amountBMin = 0 * 1e18;
        lpTokenAddress =  IFactory(UniswapFactoryAddress).getPair(tokenUSDC, tokenDAI);
        IERC20(lpTokenAddress).approve(address(app), liquidityAmount);
        app.removeLiquidity(lpTokenAddress, liquidityAmount, amountAMin, amountBMin, user, deadline_);

        vm.stopPrank();
    }

}