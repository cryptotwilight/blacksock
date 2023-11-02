// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Stream Module Factory 
  * @author cryptotwilight
  * @dev This is the Stream Module Factory implementation the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSFactory.sol";

import "../../interfaces/factory/IBKSStreamModuleFactory.sol";

import "../module/BKSStreamModule.sol";

contract BKSStreamModuleFactory is BKSFactory, IBKSStreamModuleFactory {

    string constant vname = "BKS_STREAM_MODULE_FACTORY_CORE";
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

    function getStreamModules() view external returns (address [] memory streamModules_){
        return modules; 
    }

    function isKnownStreamModule(address _address) view external returns (bool _isKnownStreamModule){
        return isKnownModule[_address];
    }

    function createStreamModule(address _owner, address _opsRegistry, address _moduleRegister) external systemOnly returns (address _streamModule){
        _streamModule = address(new BKSStreamModule(_owner, _opsRegistry, _moduleRegister));
        modules.push(_streamModule);
        isKnownModule[_streamModule];
        registerAddressWithDirectory(_streamModule, _owner);
        return _streamModule; 
    }
}