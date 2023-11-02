// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - People Module 
  * @author cryptotwilight
  * @dev This is the People Module Factory implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSFactory.sol";

import "../../interfaces/factory/IBKSPeopleModuleFactory.sol";

import "../module/BKSPeopleModule.sol";

contract BKSPeopleModuleFactory is BKSFactory, IBKSPeopleModuleFactory {


    string constant vname = "BKS_PEOPLE_MODULE_FACTORY_CORE";
    uint256 constant vversion = 1; 

    address [] modules; 
    mapping(address=>bool) isKnownModule; 

    constructor(address _opsRegister) BKSFactory(_opsRegister){
    }

    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getPeopleModules() view external returns (address [] memory streamModules_){
        return modules; 
    }

    function isKnownPeopleModule(address _address) view external returns (bool _isKnownPeopleModule){
        return isKnownModule[_address];
    }   

    function createPeopleModule(address _owner, address _opsRegistry, address _moduleRegister) external systemOnly returns (address _peopleModule){
        _peopleModule = address(new BKSPeopleModule(_owner, _opsRegistry, _moduleRegister));
        modules.push(_peopleModule);
        isKnownModule[_peopleModule];
        registerAddressWithDirectory(_peopleModule, _owner);
        return _peopleModule; 
    }

}