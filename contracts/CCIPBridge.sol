// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/utils/Context.sol';
import { CCIPReceiver } from '@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol';
import { IRouterClient } from '@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol';
import { Client } from '@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol';
import './interfaces/IERC20Mintable.sol';
import './interfaces/ICCIPConfigurations.sol';

contract CCIPBridge is CCIPReceiver, Context {
  using SafeERC20 for IERC20Mintable;

  struct BridgeTransfer {
    address user;
    address sourceToken;
    address targetToken;
    uint256 amount;
  }

  IRouterClient public bridgeRouter;
  ICCIPConfigurations public bridgeConfigs;

  event TokensSent(
    bytes32 indexed messageId,
    uint64 indexed chainSelector,
    address receiver,
    address token,
    uint256 amount,
    uint256 fees
  );
  event TokensReceived(
    bytes32 indexed messageId,
    uint64 indexed chainSelector,
    address receiver,
    address token,
    uint256 amount
  );

  constructor(
    IRouterClient _bridgeRouter,
    ICCIPConfigurations _bridgeConfigs
  ) CCIPReceiver(address(_bridgeRouter)) {
    bridgeRouter = _bridgeRouter;
    bridgeConfigs = _bridgeConfigs;
  }

  function bridge(
    uint64 _chain,
    address _user,
    address _token,
    uint256 _amount
  ) external payable returns (bytes32 _messageId) {
    require(bridgeConfigs.enabled(), 'DISABLED');
    ICCIPConfigurations.TokenConfig memory _config = bridgeConfigs.get(
      _token,
      _chain
    );
    require(_config.enabled, 'BRDISABLED');
    _processInbound(_token, _msgSender(), _amount, _config.isMintBurn);
    (Client.EVM2AnyMessage memory _evm2AnyMessage, uint256 _fees) = _getMsgFee(
      _config,
      _user,
      _amount
    );
    require(msg.value >= _fees, 'FEES');

    uint256 _refund = msg.value - _fees;
    if (_refund > 0) {
      (bool _wasRef, ) = payable(_msgSender()).call{ value: _refund }('');
      require(_wasRef, 'REFUND');
    }
    _messageId = bridgeRouter.ccipSend{ value: _fees }(_chain, _evm2AnyMessage);
    emit TokensSent(_messageId, _chain, _user, _token, _amount, _fees);
    return _messageId;
  }

  function getMsgFee(
    ICCIPConfigurations.TokenConfig memory _config,
    address _user,
    uint256 _amount
  ) external view returns (uint256) {
    (, uint256 _fee) = _getMsgFee(_config, _user, _amount);
    return _fee;
  }

  function _getMsgFee(
    ICCIPConfigurations.TokenConfig memory _config,
    address _user,
    uint256 _amount
  ) internal view returns (Client.EVM2AnyMessage memory, uint256) {
    Client.EVM2AnyMessage memory _evm2AnyMessage = _buildMsg(
      _config,
      _user,
      _amount
    );
    return (
      _evm2AnyMessage,
      bridgeRouter.getFee(_config.chain, _evm2AnyMessage)
    );
  }

  function _buildMsg(
    ICCIPConfigurations.TokenConfig memory _config,
    address _user,
    uint256 _amount
  ) internal view returns (Client.EVM2AnyMessage memory) {
    Client.EVM2AnyMessage memory evm2AnyMessage = Client.EVM2AnyMessage({
      receiver: abi.encode(_config.targetBridge),
      data: abi.encode(
        BridgeTransfer({
          user: _user,
          sourceToken: _config.sourceToken,
          targetToken: _config.targetToken,
          amount: _amount
        })
      ),
      tokenAmounts: new Client.EVMTokenAmount[](0),
      extraArgs: Client._argsToBytes(
        Client.EVMExtraArgsV1({ gasLimit: bridgeConfigs.gasLimit() })
      ),
      feeToken: address(0) // native
    });
    return evm2AnyMessage;
  }

  function _ccipReceive(
    Client.Any2EVMMessage memory _message
  ) internal override {
    BridgeTransfer memory _tfrInfo = abi.decode(
      _message.data,
      (BridgeTransfer)
    );
    ICCIPConfigurations.TokenConfig memory _config = bridgeConfigs.get(
      _tfrInfo.targetToken,
      _message.sourceChainSelector
    );
    require(
      abi.decode(_message.sender, (address)) == _config.targetBridge,
      'AUTH'
    );
    address _user = _tfrInfo.user;
    address _token = _tfrInfo.targetToken;
    uint256 _amount = _tfrInfo.amount;
    _processOutbound(_token, _user, _amount, _config.isMintBurn);
    emit TokensReceived(
      _message.messageId,
      _message.sourceChainSelector,
      _user,
      _token,
      _amount
    );
  }

  function _processInbound(
    address _token,
    address _user,
    uint256 _amount,
    bool _mintBurn
  ) internal {
    IERC20Mintable(_token).safeTransferFrom(_user, address(this), _amount);
    if (_mintBurn) {
      IERC20Mintable(_token).burn(_amount);
    }
  }

  function _processOutbound(
    address _token,
    address _user,
    uint256 _amount,
    bool _mintBurn
  ) internal {
    if (_mintBurn) {
      IERC20Mintable(_token).mint(_user, _amount);
    } else {
      IERC20Mintable(_token).safeTransfer(_user, _amount);
    }
  }
}
