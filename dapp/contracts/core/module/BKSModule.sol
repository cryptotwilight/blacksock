// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module 
  * @author cryptotwilight
  * @dev This is the Module super contract implementation for the Black Sock decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/IBlackSock.sol";
import "../../interfaces/system/IBKSRewardsService.sol";


import "../../interfaces/module/IBKSModule.sol";
import "../../interfaces/module/IBKSModuleRegister.sol";

import "../../interfaces/system/IBKSVersion.sol";
import "../../interfaces/system/IBKSOpsRegister.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract BKSModule is IBKSModule, IBKSVersion { 

    using Strings for address; 

    string constant BKS_ADMIN_CA = "BKS_ADMIN";
    string constant BLACK_SOCK_CA = "BLACK_SOCK_CORE";
    string constant BKS_REWARDS_SERVICE_CA = "BKS_REWARDS_SERVICE_CORE";

    uint256 private index; 

    modifier ownerOnly {
        require(isOwner(), string.concat( "owner only :x: ", msg.sender.toHexString()));
        _;
    }
    modifier adminOnly {
        require(adminEnabled && isAdmin(), string.concat( "admin only :x: ", msg.sender.toHexString()));
        _;
    }

    modifier admin() {
        require((adminEnabled && isAdmin()) || isOwner() , string.concat( "admin / owner only :x: ", msg.sender.toHexString()));
        _;
    }

    modifier rewarded( string memory _action) {
        _;
        IBlackSock system_ = IBlackSock(register.getAddress(BLACK_SOCK_CA));
        if(system_.isKnownOwner(owner)){
            IBKSRewardsService rewards_ = IBKSRewardsService(register.getAddress(BKS_REWARDS_SERVICE_CA));
            rewards_.issueReward(owner, _action);
        }
        
    }

    address owner; 
    bool private adminEnabled; 

    IBKSOpsRegister register; 
    IBKSModuleRegister mRegister; 

    constructor(address _owner, address _opsRegister, address _moduleRegister) { 
        owner = _owner; 
        register = IBKSOpsRegister(_opsRegister);
        mRegister = IBKSModuleRegister(_moduleRegister);
    }

    function getOwner() view external returns (address _owner) {
        return owner; 
    }

    function isAdminEnabled() view external returns (bool _isAdminEnabled) {
        return adminEnabled; 
    }

    function enableAdmin(bool _enable) external ownerOnly returns (bool _adminEnabled){
        adminEnabled = _enable;
        return adminEnabled; 
    }

    //======================================= INTERNAL ==============================================================

    function isOwner() internal view returns (bool _isOwner) {
        return msg.sender == owner; 
    }

    function isAdmin() internal view returns (bool _isAdmin) {
        return msg.sender == register.getAddress(BKS_ADMIN_CA);
    }

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

}