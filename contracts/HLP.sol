// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './LendingRewards.sol';

contract HLP is ERC20 {
  address public lendingPool;
  LendingRewards public lendingRewards;

  modifier onlyLendingPool() {
    require(_msgSender() == lendingPool, 'UNAUTHORIZED');
    _;
  }

  constructor() ERC20('HYPE LP', 'HLP') {
    lendingPool = _msgSender();
    lendingRewards = new LendingRewards(address(this));
  }

  function mint(address _wallet, uint256 _amount) external onlyLendingPool {
    _mint(_wallet, _amount);
  }

  function burn(address _wallet, uint256 _amount) external onlyLendingPool {
    _burn(_wallet, _amount);
  }

  function _canReceiveRewards(address _wallet) internal pure returns (bool) {
    return _wallet != address(0);
  }

  function _afterTokenTransfer(
    address _from,
    address _to,
    uint256 _amount
  ) internal virtual override {
    if (_canReceiveRewards(_from)) {
      lendingRewards.setShare(_from, _amount, true);
    }
    if (_canReceiveRewards(_to)) {
      lendingRewards.setShare(_to, _amount, false);
    }
  }
}
