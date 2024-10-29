// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ILendingPool {
  function toggleWhitelistCollateralPool(address pool) external;
}
