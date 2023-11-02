// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Media Module Factory
  * @author cryptotwilight
  * @dev This is the Media Module Factory implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSFactory.sol";

import "../../interfaces/factory/IBKSMediaModuleFactory.sol";

import "../module/BKSMediaModule.sol";

contract BKSMediaModuleFactory is BKSFactory, IBKSMediaModuleFactory {
    
    string constant vname = "BKS_MEDIA_MODULE_FACTORY_CORE";
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

    function getMediaModules() view external returns (address [] memory streamModules_){
        return modules; 
    }

    function isKnownMediaModule(address _address) view external returns (bool _isKnownMoneyModule){
        return isKnownModule[_address];
    }

    function createMediaModule(address _owner, address _opsRegistry, address _moduleRegister) external systemOnly returns (address _mediaModule){
        _mediaModule = address(new BKSMediaModule(_owner, _opsRegistry, _moduleRegister));
        modules.push(_mediaModule);
        isKnownModule[_mediaModule];
        return _mediaModule;
    }
}