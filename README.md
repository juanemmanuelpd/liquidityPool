# Swap App
## Overview 🪙
Add and remove liquidity to the USDC - DAI pool.
## Features 📃
* Swap your USDC for DAI
* Provide liquidity to the USDC-DAI pool to receive Liquidity Provider Tokens (LP Tokens)
* Redeem your LP Tokens to receive USD and DAI from the liquidity pool
## Technical details ⚙️
* Uniswap V2 Swap Router Address (Arbitrum)-> 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24.
* Uniswap Factory Address (Arbitrum) -> 0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9.
* Forked network for testing -> Arbitrum.
* RPC Server Address -> https://arb1.arbitrum.io/rpc.
* Framework CLI -> Foundry.
* Forge version -> 1.1.0-stable.
* Solidity compiler version -> 0.8.24.
## Deploying the contract 🛠️
1. Clone the GitHub repository.
2. Open Visual Studio Code (you should already have Foundry installed).
3. Select "File" > "Open Folder", select the cloned repository folder.
4. In the project navigation bar, open the "swapApp.t.sol" file located in the "test" folder.
5. On line 18 ("Address with USDC in Arbitrum Mainnet") enter the address of your wallet with USDC in the Arbitrum network. Note: Verify that you have at least 5 USDC on the Arbitrum network.
6. In the toolbar above, select "Terminal" > "New Terminal".
7. Select the "Git bash" terminal (previously installed).
8. Run the command `forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test` followed by the name of a test function to test it and verify the smart contract functions are working correctly. For example, run `forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test testHasBeenDeployedCorrectly` to test the `testHasBeenDeployedCorrectly` function.
9. Run `forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test testSwapTokensCorrectly` to swap your 5 USDC for DAI. This is just a test on the forked Arbitrum network, so your USDC will remain in your wallet after this.
10. If you want to change the amount of USDC to swap, you will have to edit the `amountIn` variable in the `testSwapTokensCorrectly()` function.
11. Run `forge coverage --fork-url https://arb1.arbitrum.io/rpc` to generate a code coverage report, which allows you to verify which parts of the "swapApp.sol" script code (in the "src" folder) are executed by the tests. This helps identify areas outside the coverage that could be exposed to errors/vulnerabilities.
## Functions 📌
* `swapTokens()` -> Swap USDC for DAI.
## Testing functions ⌨️
* `testHasBeenDeployedCorrectly()` -> Verify that the swap app has been correctly initialized with the correct router address (`uniswapV2SwapRouterAddress`).
* `testSwapTokensCorrectly()` -> Verify that the 5 USDC to DAI swap was successful. Note: The amount of DAI you receive will vary depending on the liquidity in the USDC -> DAI liquidity pool.
## Forge Coverage ✅
![Forge Coverage](images/forgeCoverage.png)  

CODE IS LAW!
