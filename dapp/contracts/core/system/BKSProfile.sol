// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Profile
  * @author cryptotwilight
  * @dev This is the Profile implementation for the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/system/IBKSProfile.sol";
import "../../interfaces/system/IBKSVersion.sol";
import "../../interfaces/system/IBKSProfile.sol";
import "../../interfaces/system/IBKSOpsRegister.sol";

import "../../interfaces/module/IBKSModuleRegister.sol";

import {Price} from "../../interfaces/module/IBKSMoneyModule.sol";

contract BKSProfile is IBKSProfile, IBKSProfileWriter, IBKSVersion { 

    string constant name = "BKS_PROFILE_NC"; 
    uint256 constant version = 1; 

    modifier ownerOnly {
        require(isOwner(), "owner only");
        _;
    }
    modifier adminOnly {
        require(adminEnabled && isAdmin(), "admin only");
        _;
    }

    modifier admin() {
        require((adminEnabled && isAdmin()) || isOwner() , " admin only ");
        _;
    }

    string constant BKS_ADMIN_CA = "BKS_ADMIN";
    IBKSOpsRegister register;
    IBKSModuleRegister moduleRegister; 
    Avatar avatar; 
    Price [] prices;

    address owner; 
    bool adminEnabled; 

    Notification [] notifications; 

    constructor(address _owner, address _register,  address _moduleRegister) {
        owner = _owner; 
        register = IBKSOpsRegister(_register);
        moduleRegister = IBKSModuleRegister(_moduleRegister);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getAvatar() view external returns (Avatar memory _avatar){
        return avatar; 
    }

    function getOwner() view external returns (address _owner) {
        return owner; 
    }

    function getModuleRegister() view external returns (address _moduleRegister){
        return address(moduleRegister);
    }

    function getPrices() view external returns (Price [] memory _price){
        return prices; 
    }

    function getNotifications() view external returns (Notification [] memory _notification){
        return notifications; 
    }

    function setUserAvatar(Avatar memory _avatar) external ownerOnly returns (bool _set) {
        avatar = _avatar; 
        return true; 
    }

    function notify(Notification memory _notification) external returns (bool _notified){
        notifications.push(_notification);
        return true; 
    }

    function enableAdmin() external ownerOnly returns (bool _adminEnabled) {
        adminEnabled = true; 
        return adminEnabled; 
    }

    //=================================== INTERNAL ==============================

    function isOwner() internal view returns (bool _isOwner) {
        return msg.sender == owner; 
    }

    function isAdmin() internal view returns (bool _isAdmin) {
        return msg.sender == register.getAddress(BKS_ADMIN_CA);
    }


}