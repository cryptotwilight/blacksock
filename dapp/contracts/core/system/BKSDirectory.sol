// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Directory
  * @author cryptotwilight
  * @dev This is the Directory implementation for the Black Sock decentralized social protocol 
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSSystemContract.sol";

contract BKSDirectory is BKSSystemContract, IBKSDirectory {

    string constant name  = "BKS_DIRECTORY_CORE";
    uint256 constant version = 1; 

    address [] addresses; 
    mapping(address=>bool) knownBKSAddress;
    mapping(address=>address) ownerByAddress; 
    mapping(address=>address[]) addressesByOwner; 

    constructor(address _register) BKSSystemContract(_register){
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getBKSAddresses() view external returns (address [] memory _addresses){
        return addresses; 
    }

    function getAddressOwner(address _address) view external returns (address _owner) {
        return ownerByAddress[_address];
    }

    function getAddresses(address _owner) view external returns (address [] memory _addresses) {
        return addressesByOwner[_owner];
    }

    function isBKSAddress(address _address) view  external returns (bool _isBKSAddress){
        return knownBKSAddress[_address];
    }

    function addBKSAddress(address _address, address _owner) external systemOnly returns (bool _added){
        addresses.push(_address);
        knownBKSAddress[_address] = true; 
        ownerByAddress[_address] = _owner; 
        addressesByOwner[_owner].push(_address);
        return true;
    }


}


