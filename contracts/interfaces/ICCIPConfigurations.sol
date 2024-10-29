// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ICCIPConfigurations {
  struct TokenConfig {
    bool enabled;
    address targetBridge;
    address sourceToken;
    bool isMintBurn;
    uint64 chain;
    address targetToken;
  }

  function enabled() external view returns (bool);

  function gasLimit() external view returns (uint256);

  function get(
    address sourceToken,
    uint64 chainSelector
  ) external returns (TokenConfig memory);
}
