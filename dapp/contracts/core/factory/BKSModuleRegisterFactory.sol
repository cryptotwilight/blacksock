// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Module Register Factory 
  * @author cryptotwilight
  * @dev This is the Module Register Factory implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/factory/IBKSModuleRegisterFactory.sol";

import "../module/BKSModuleRegister.sol";

import "./BKSFactory.sol";

contract BKSModuleRegisterFactory is BKSFactory, IBKSModuleRegisterFactory { 

    string constant vname = "BKS_MODULE_REGISTER_FACTORY_CORE";
    uint256 constant vversion = 2; 

    address [] registries; 
    mapping(address=>bool) isKnownRegister; 

    constructor(address _opsRegister) BKSFactory(_opsRegister){
    }

    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getModuleRegisters() view external returns (address[] memory _registries){
        return registries; 
    }

    function isKnownModuleRegister(address _registry) view external returns (bool _isKnown){
        return isKnownRegister[_registry];
    }

    function createModuleRegister(address _owner) external systemOnly returns (address _register){
        _register = address(new BKSModuleRegister(_owner, address(register)));
        registries.push(_register);
        isKnownRegister[_register] = true; 
        registerAddressWithDirectory(_register, _owner);
        return _register; 
    }
}