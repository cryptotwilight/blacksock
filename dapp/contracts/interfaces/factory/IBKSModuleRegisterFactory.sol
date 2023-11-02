// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Module Register Factory
  * @author cryptotwilight
  * @dev This is the factory used to create Module Registers for users in the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSModuleRegisterFactory { 

    function getModuleRegisters() view external returns (address[] memory _registries);

    function isKnownModuleRegister(address _registry) view external returns (bool _isKnown);

    function createModuleRegister(address _owner) external returns (address _moduleRegister);

}