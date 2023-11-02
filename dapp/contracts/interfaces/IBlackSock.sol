// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Core Interface
  * @author cryptotwilight
  * @dev This is the main access interface into the Black Sock decentralized social protocol
  * @custom:buidl'd at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct BlackSockStats { 

    uint256 profileCount; 
    uint256 createDate; 
}

interface IBlackSock { 
    
    function getStats() view external returns (BlackSockStats memory _stats);
    
    function isKnownOwner(address _user) view external returns (bool _isKnownOwner);

    function findProfile (address _user) view external returns (address _profile);

    function createProfile() external returns (address _profile);
}