// License 
// SPDX-License-Identifier: MIT

// Solidity compiler version
pragma solidity 0.8.24;

// Interface
interface IFactory{

    function getPair(address tokenA, address tokenB) external view returns (address pair);

}