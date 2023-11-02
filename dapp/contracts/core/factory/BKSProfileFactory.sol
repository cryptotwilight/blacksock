// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Profile Factory 
  * @author cryptotwilight
  * @dev This is the Profile Factory implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/system/IBKSOpsRegister.sol";
import "../../interfaces/system/IBKSVersion.sol";
import "../../interfaces/factory/IBKSProfileFactory.sol";
import "../../interfaces/factory/IBKSModuleRegisterFactory.sol";
import "../../interfaces/factory/IBKSMediaModuleFactory.sol";
import "../../interfaces/factory/IBKSMoneyModuleFactory.sol";
import "../../interfaces/factory/IBKSPeopleModuleFactory.sol";
import "../../interfaces/factory/IBKSRewardModuleFactory.sol";
import "../../interfaces/factory/IBKSStreamModuleFactory.sol";


import "../system/BKSProfile.sol";

import "./BKSFactory.sol";

contract BKSProfileFactory is BKSFactory, IBKSProfileFactory {    

    string constant name = "BKS_PROFILE_FACTORY_CORE";
    uint256 constant version = 2; 

    string constant MODULE_REGISTER_FACTORY_CA = "BKS_MODULE_REGISTER_FACTORY_CORE";
    string constant MEDIA_MODULE_FACTORY_CA = "BKS_MEDIA_MODULE_FACTORY_CORE";
    string constant MONEY_MODULE_FACTORY_CA = "BKS_MONEY_MODULE_FACTORY_CORE";
    string constant PEOPLE_MODULE_FACTORY_CA = "BKS_PEOPLE_MODULE_FACTORY_CORE";
    string constant REWARD_MODULE_FACTORY_CA = "BKS_REWARD_MODULE_FACTORY_CORE";
    string constant STREAM_MODULE_FACTORY_CA = "BKS_STREAM_MODULE_FACTORY_CORE";
    
    address [] profiles; 
    mapping(address=>bool) isKnownProfileByAddress; 
    mapping(address=>address) profileByUser;
    mapping(address=>bool) hasProfileByUser; 

    constructor(address _register) BKSFactory(_register) { 
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function hasProfile(address _user) view external returns (bool _hasProfile){
        return hasProfileByUser[_user];
    }
    function getProfile(address _user) view external returns (address _profile){
        return profileByUser[_user];
    }

    function isKnownProfile(address _address) view external returns (bool _isKnownProfile) {
        return isKnownProfileByAddress[_address];
    }

    function getProfiles() view external adminOnly returns (address [] memory _profiles){
        return profiles; 
    }

    function createProfile(address _user) external systemOnly returns (address _profile){
        IBKSModuleRegisterFactory moduleRegisterFactory_ = IBKSModuleRegisterFactory(register.getAddress(MODULE_REGISTER_FACTORY_CA));

        address moduleRegister_ = moduleRegisterFactory_.createModuleRegister(_user);
        _profile = address(new BKSProfile(_user, address(register), moduleRegister_ ));
        IBKSModuleRegister mRegister_ = IBKSModuleRegister(moduleRegister_); 
        mRegister_.registerModule(IBKSMediaModuleFactory(register.getAddress(MEDIA_MODULE_FACTORY_CA)).createMediaModule(_user, address(register), moduleRegister_));
        mRegister_.registerModule(IBKSMoneyModuleFactory(register.getAddress(MONEY_MODULE_FACTORY_CA)).createMoneyModule(_user, address(register), moduleRegister_));
        mRegister_.registerModule(IBKSPeopleModuleFactory(register.getAddress(PEOPLE_MODULE_FACTORY_CA)).createPeopleModule(_user, address(register), moduleRegister_));
        mRegister_.registerModule(IBKSRewardModuleFactory(register.getAddress(REWARD_MODULE_FACTORY_CA)).createRewardModule(_user, address(register), moduleRegister_));
        mRegister_.registerModule(IBKSStreamModuleFactory(register.getAddress(STREAM_MODULE_FACTORY_CA)).createStreamModule(_user, address(register), moduleRegister_));
        profiles.push(_profile);
        profileByUser[_user] = _profile;
        hasProfileByUser[_user] = true; 
        isKnownProfileByAddress[_profile] = true;
        registerAddressWithDirectory(_profile, _user);
        return _profile; 
    }

}