// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './RewardsTracker.sol';

contract LendingRewards is RewardsTracker {
  constructor(address _token) RewardsTracker(_token) {}
}
