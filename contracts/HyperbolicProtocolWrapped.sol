// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './HyperbolicProtocol.sol';

contract HyperbolicProtocolWrapped is HyperbolicProtocol {
  uint256 _maxTotalSupply;
  mapping(address => bool) public minter;

  event Mint(address indexed minter, address wallet, uint256 amount);

  modifier onlyMinter() {
    require(minter[_msgSender()], 'MINTER');
    _;
  }

  constructor(
    ITwapUtils _twapUtils,
    INonfungiblePositionManager _manager,
    ISwapRouter _swapRouter,
    address _factory,
    address _WETH9
  ) HyperbolicProtocol(_twapUtils, _manager, _swapRouter, _factory, _WETH9) {
    _maxTotalSupply = totalSupply();
  }

  function mint(address _wallet, uint256 _amount) external onlyMinter {
    require(totalSupply() + _amount <= _maxTotalSupply, 'MAX');
    _mint(_wallet, _amount);
    emit Mint(_msgSender(), _wallet, _amount);
  }

  function setMinter(address _wallet, bool _isMinter) external onlyOwner {
    require(minter[_wallet] != _isMinter, 'TOGGLE');
    minter[_wallet] = _isMinter;
  }
}
