// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Directory
  * @author cryptotwilight
  * @dev This is the directory used to keep track of all user generated addresses in the Black Sock decentralized protocol 
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

interface IBKSDirectory { 

    function getBKSAddresses() view external returns (address [] memory _addresses);

    function isBKSAddress(address _address) view external returns (bool _isBKSAddress);

    function getAddressOwner(address _address) view external returns (address _owner);

    function addBKSAddress(address _address, address _userOwner) external returns (bool _added);
}