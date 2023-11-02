// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Profile Register
  * @author cryptotwilight
  * @dev This is the decentralized register of all profiles active in the decentralized social protocol
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

interface IBKSProfileRegister {

    function getProfile(uint256 _registrationId) view external returns (address _profile);

    function findProfileByOwner(address _owner) view external returns (address _profile);

    function findProfileByName(string memory _name) view external returns (address [] memory _profiles);

    function isRegisteredProfile(address _profile) view external returns (bool _isRegistered);

    function registerProfile(address _profile) external returns (uint256 _registrationId);
}