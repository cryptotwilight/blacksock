// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - People Module 
  * @author cryptotwilight
  * @dev This is the factory used to create People Modules for users in the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSPeopleModuleFactory { 

    function getPeopleModules() view external returns (address [] memory streamModules_);

    function isKnownPeopleModule(address _address) view external returns (bool _isKnownPeopleModule);

    function createPeopleModule(address _owner, address _opsRegistry,  address _moduleRegister) external returns (address _peopleModule);
}