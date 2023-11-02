// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Money Module Factory 
  * @author cryptotwilight
  * @dev This is the factory used to create Money Modules for users in the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

interface IBKSMoneyModuleFactory {

    function getMoneyModules() view external returns (address [] memory streamModules_);

    function isKnownMoneyModule(address _address) view external returns (bool _isKnownMoneyModule);

    function createMoneyModule(address _owner, address _opsRegistry, address _moduleRegister) external returns (address _moneyModule);

}