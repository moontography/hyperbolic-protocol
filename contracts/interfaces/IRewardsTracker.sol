// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IRewardsTracker {
  function claimReward() external;

  function depositRewards() external payable;

  function getShares(address wallet) external view returns (uint256);

  function setShare(
    address shareholder,
    uint256 balanceUpdate,
    bool isRemoving
  ) external;
}
