// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module Register
  * @author cryptotwilight
  * @dev This is the Module Register that is used to register an individual's modules in the Black Sock decentralized social protocol  
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSModuleRegister { 

    function getModule(uint256 _registrationId) view external returns (address _module);

    function getModules() view external returns (address [] memory _modules);

    function getModule(string memory _name) view external returns (address _module);

    function registerModule(address _module) external returns (uint256 _registrationId);

}