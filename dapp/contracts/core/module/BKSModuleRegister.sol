// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module Register 
  * @author cryptotwilight
  * @dev This is the Module Register implementation the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSModule.sol";

import "../../interfaces/module/IBKSModuleRegister.sol";
import "../../interfaces/system/IBKSDirectory.sol";


contract BKSModuleRegister is  IBKSModuleRegister, IBKSVersion {

    modifier ownerContractsOnly() {
        require(IBKSDirectory(register.getAddress(BKS_DIRECTORY_CA)).getAddressOwner(msg.sender) == owner 
                                    || register.isSystemAddress(msg.sender), "owner / admin only");
        _;
    }

    string constant vname = "BKS_MODULE_REGISTER_NC";
    uint256 constant vversion = 2; 

    string constant BKS_DIRECTORY_CA = "BKS_DIRECTORY_CORE";

    uint256 constant UNIT_MAX = 10;
    
    address owner; 
    IBKSOpsRegister register;

    uint256 index; 

    address [] modules;
    mapping(string=>address) moduleByName; 
    mapping(uint256=>address) moduleByRegistrationId; 

    constructor(address _owner, address _opsRegister) {
        owner = _owner; 
        register = IBKSOpsRegister(_opsRegister); 
    }
   function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getModule(uint256 _registrationId) view external returns (address _module){
        return moduleByRegistrationId[_registrationId];
    }

    function getModules() view external returns (address [] memory _modules){
        return modules;
    }       

    function getModule(string memory _name) view external returns (address _module){
        return moduleByName[_name];
    }

    function registerModule(address _module) external ownerContractsOnly returns (uint256 _registrationId){
        modules.push(_module);
        _registrationId = getIndex(); 
        moduleByRegistrationId[_registrationId] = _module; 
        moduleByName[IBKSVersion(_module).getName()] = _module; 
        return _registrationId; 
    }   

    //=================================== INTERNAL ========================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }
}