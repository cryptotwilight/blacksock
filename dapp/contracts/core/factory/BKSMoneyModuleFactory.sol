// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Money Module 
  * @author cryptotwilight
  * @dev This is the Money Module Factory implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSFactory.sol";

import "../../interfaces/factory/IBKSMoneyModuleFactory.sol";
import "../module/BKSMoneyModule.sol";

contract BKSMoneyModuleFactory is BKSFactory, IBKSMoneyModuleFactory {

    string constant vname = "BKS_MONEY_MODULE_FACTORY_CORE";
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

    function getMoneyModules() view external returns (address [] memory _moneyModules){
        return modules;
    }

    function isKnownMoneyModule(address _address) view external returns (bool _isKnownMoneyModule){
        return isKnownModule[_address];
    }   

    function createMoneyModule(address _owner, address _opsRegistry, address _moduleRegister) external systemOnly returns (address _moneyModule){
        _moneyModule = address(new BKSMoneyModule(_owner, _opsRegistry, _moduleRegister));
        modules.push(_moneyModule);
        isKnownModule[_moneyModule];
        registerAddressWithDirectory(_moneyModule, _owner);
        return _moneyModule;
    }

}