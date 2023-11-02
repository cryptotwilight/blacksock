// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Reward Module Factory
  * @author cryptotwilight
  * @dev This is the factory used to create Reward Modules in the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSRewardModuleFactory {

    function getRewardModules() view external returns (address [] memory streamModules_);

    function isKnownRewardModule(address _address) view external returns (bool _isRewardStreamModule);

    function createRewardModule(address _owner, address _opsRegistry,  address _moduleRegister) external returns (address _rewardModule);
}