// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts/access/Ownable.sol';
import './interfaces/ICCIPConfigurations.sol';

contract CCIPConfigurations is ICCIPConfigurations, Ownable {
  bool public override enabled = true;
  uint256 public override gasLimit = 400_000;

  // source token => target chain selector => config
  mapping(address => mapping(uint64 => TokenConfig)) _configs;

  function get(
    address _sourceToken,
    uint64 _chain
  ) external view override returns (TokenConfig memory) {
    return _configs[_sourceToken][_chain];
  }

  function setConfig(
    address _targetBridge,
    uint64 _chain,
    address _sourceToken,
    bool _isMintBurn,
    address _targetToken,
    bool _enabled
  ) external onlyOwner {
    _configs[_sourceToken][_chain] = TokenConfig({
      enabled: _enabled,
      targetBridge: _targetBridge,
      sourceToken: _sourceToken,
      isMintBurn: _isMintBurn,
      chain: _chain,
      targetToken: _targetToken
    });
  }

  function setGasLimit(uint256 _gasLimit) external onlyOwner {
    require(gasLimit != _gasLimit, 'CHANGE');
    gasLimit = _gasLimit;
  }

  function setConfigEnabled(
    address _sourceToken,
    uint64 _chain,
    bool _isEnabled
  ) external onlyOwner {
    require(_configs[_sourceToken][_chain].enabled != _isEnabled);
    _configs[_sourceToken][_chain].enabled = _isEnabled;
  }

  function setEnabled(bool _isEnabled) external onlyOwner {
    require(enabled != _isEnabled);
    enabled = _isEnabled;
  }
}
