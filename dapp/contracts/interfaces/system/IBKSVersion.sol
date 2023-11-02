// SPDX-License-Identifier: APACHE 2.0
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