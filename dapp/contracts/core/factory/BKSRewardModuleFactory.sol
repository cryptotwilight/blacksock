// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Reward Module Factory 
  * @author cryptotwilight
  * @dev This is the Reward Module Factory implementation the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSFactory.sol";

import "../../interfaces/factory/IBKSRewardModuleFactory.sol";

import "../factory/BKSFactory.sol";
import "../module/BKSRewardModule.sol";

contract BKSRewardModuleFactory is BKSFactory, IBKSRewardModuleFactory {

    string constant vname = "BKS_REWARD_MODULE_FACTORY_CORE";
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

    function getRewardModules() view external returns (address [] memory streamModules_){
        return modules; 
    }

    function isKnownRewardModule(address _address) view external returns (bool _isRewardStreamModule){
        return isKnownModule[_address];
    }

    function createRewardModule(address _owner, address _opsRegistry, address _moduleRegister) external systemOnly returns (address _rewardModule){
        _rewardModule = address(new BKSRewardModule(_owner, _opsRegistry, _moduleRegister));
        modules.push(_rewardModule);
        isKnownModule[_rewardModule];
        registerAddressWithDirectory(_rewardModule, _owner);
        return _rewardModule; 
    }
}