// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts/interfaces/IERC20.sol';

interface IERC20Mintable is IERC20 {
  function burn(uint256 amount) external;

  function mint(address wallet, uint256 amount) external;
}
