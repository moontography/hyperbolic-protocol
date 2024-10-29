// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IHyperbolicProtocol {
  function poolBalToMarketCapRatio()
    external
    view
    returns (uint256 lendPoolETHBal, uint256 marketCapETH);

  function poolToMarketCapTarget() external view returns (uint32);
}
