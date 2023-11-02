// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Profile Register
  * @author cryptotwilight
  * @dev This is the implementation contract for the Profile Register for the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/system/IBKSProfileRegister.sol";
import "../../interfaces/system/IBKSProfile.sol";

import "../../interfaces/factory/IBKSProfileFactory.sol";

import "./BKSSystemContract.sol";

contract BKSProfileRegister is BKSSystemContract, IBKSProfileRegister { 

    string constant name = "BKS_PROFILE_REGISTER_CORE"; 
    uint256 constant version = 1; 

    string constant BKS_PROFILE_FACTORY_CA = "BKS_PROFILE_FACTORY_CORE";

    mapping(uint256=>address) profileByRegistrationId; 
    mapping(address=>address) profileByOwner; 
    mapping(string=>address[]) profileByName; 
    mapping(address=>bool) isRegistered; 

    constructor(address _opsRegister) BKSSystemContract(_opsRegister) {
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getProfile(uint256 _registrationId) view external returns (address _profile){
        return profileByRegistrationId[_registrationId];
    }

    function findProfileByOwner(address _owner) view external returns (address _profile){
        return profileByOwner[_owner];
    }

    function findProfileByName(string memory _name) view external returns (address [] memory _profiles){
        return profileByName[_name];
    }

    function isRegisteredProfile(address _profile) view external returns (bool _isRegistered){
        return isRegistered[_profile];
    }

    function registerProfile(address _profile) external systemOnly returns (uint256 _registrationId){
        require(IBKSProfileFactory(register.getAddress(BKS_PROFILE_FACTORY_CA)).isKnownProfile(_profile), "register fail: unknown profile");
        _registrationId = getIndex(); 
        profileByRegistrationId[_registrationId] = _profile; 
        IBKSProfile profile_ = IBKSProfile(_profile);
        profileByOwner[profile_.getOwner()] = _profile; 
        profileByName[profile_.getAvatar().name].push(_profile);
        isRegistered[_profile] = true; 
        return _registrationId;  
    }
}