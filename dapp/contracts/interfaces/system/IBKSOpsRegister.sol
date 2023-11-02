// SPDX-License-Identifier: APACHE 2.0
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