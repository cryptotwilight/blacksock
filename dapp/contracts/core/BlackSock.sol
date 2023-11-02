// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Core implementation 
  * @author cryptotwilight
  * @dev This is the core implementation contract for the Black Sock decentralized social protocol. Users start here to create their on chain profiles  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../interfaces/system/IBKSVersion.sol";
import "../interfaces/IBlackSock.sol";
import "../interfaces/system/IBKSOpsRegister.sol";
import "../interfaces/system/IBKSProfileRegister.sol";
import "../interfaces/factory/IBKSProfileFactory.sol";

import "./system/BKSSystemContract.sol";

contract BlackSock is BKSSystemContract, IBlackSock {

    string constant name = "BLACK_SOCK_CORE"; 
    uint256 constant version = 1; 

    string constant BKS_PROFILE_REGISTER_CA = "BKS_PROFILE_REGISTER_CORE";
    string constant BKS_PROFILE_FACTORY_CA = "BKS_PROFILE_FACTORY_CORE";

    address [] profiles;    

    mapping(address=>bool) knownOwner; 

    constructor(address _register) BKSSystemContract(_register) {
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }
    
    function getStats() view external returns (BlackSockStats memory _stats){
        return BlackSockStats({
                                    profileCount : IBKSProfileFactory(register.getAddress(BKS_PROFILE_FACTORY_CA)).getProfiles().length,
                                    createDate : block.timestamp
                                });
    }
    
    function findProfile (address _user) view external returns (address _profile){
        return IBKSProfileFactory(register.getAddress(BKS_PROFILE_FACTORY_CA)).getProfile(_user);
    }

    function createProfile() external returns (address _profile) {
        _profile =  IBKSProfileFactory(register.getAddress(BKS_PROFILE_FACTORY_CA)).createProfile(msg.sender);
        IBKSProfileRegister(register.getAddress(BKS_PROFILE_REGISTER_CA)).registerProfile(_profile);
        return _profile; 

    }

    function isKnownOwner(address _user) view external returns (bool _isKnownOwner) {
        return knownOwner[_user];
    }

}