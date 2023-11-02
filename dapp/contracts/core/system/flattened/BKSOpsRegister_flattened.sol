// SPDX-License-Identifier: APACHE 2.0
// File: contracts/interfaces/system/IBKSVersion.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Version
  * @author cryptotwilight
  * @dev This is the versioning and introspection interface used by the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSVersion { 

    function getName() view external returns (string memory _name);
    
    function getVersion() view external returns (uint256 _version);

}
// File: contracts/interfaces/system/IBKSOpsRegister.sol


pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Operations Register 
  * @author cryptotwilight
  * @dev This is the Operations Register that is used to keep track of all system level contracts in the Black Sock decentralized social protocol 
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSOpsRegister { 

    function getNames() view external returns (string [] memory _names);

    function getAddresses() view external returns (string [] memory _name, address [] memory _address);

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

    function isSystemAddress(address _address) view external returns (bool _isSystemAddress);

}
// File: contracts/core/system/BKSOpsRegister.sol


pragma solidity >=0.8.2 <0.9.0;

 /**
  * @title Black Sock - Operations Register
  * @author cryptotwilight
  * @dev This is the Operations Register implementation for the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */



contract BKSOpsRegister is IBKSOpsRegister, IBKSVersion {

    modifier adminOnly() {
        require(msg.sender == admin, "admin only");
        _;
    }

    string constant name = "BKS_OPS_REGISTER_CORE";
    uint256 constant version = 1; 

    address admin; 
    string [] names; 
    mapping(string=>address) addressByName; 
    mapping(address=>bool) isSysAddress; 
    mapping(address=>string) nameByAddress; 

    constructor(address _admin) { 
        admin = _admin; 
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }
    function getNames() view external returns (string [] memory _names){
        return names; 
    }

    function getAddresses() view external returns (string [] memory _name, address [] memory _address){
        _address = new address[](names.length);
        for(uint256 x = 0; x < names.length; x++) {
            _address[x] = addressByName[names[x]];
        }   
        return (names, _address);
    }

    function getAddress(string memory _name) view external returns (address _address){
        return addressByName[_name];
    }

    function getName(address _address) view external returns (string memory _name){
        return nameByAddress[_address];
    }

    function isSystemAddress(address _address) view external returns (bool _isSystemAddress){
        return isSysAddress[_address];
    }

    function addBKSVersionAddress(address _address, bool _isSystemAddress) external adminOnly returns (bool _added) {
        return addAddressInternal(IBKSVersion(_address).getName(), _address, _isSystemAddress);
    }

    function addAddress(string memory _name, address _address, bool _isSystemAddress) external adminOnly returns (bool _added) {
        return addAddressInternal(_name, _address, _isSystemAddress); 
    }

    function changeAdmin(address _newAdmin) external adminOnly returns (bool _changed){
        admin = _newAdmin; 
        return true; 
    }

    // =========================== INTERNAL ===========================================

    function addAddressInternal(string memory _name, address _address, bool _isSystemAddress) internal returns (bool _added) {
        names.push(_name);
        nameByAddress[_address] = _name; 
        addressByName[_name] = _address; 
        isSysAddress[_address] = _isSystemAddress;
        return true; 
    }

}