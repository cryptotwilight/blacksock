// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Profile Factory 
  * @author cryptotwilight
  * @dev This is the factory used to create user profiles in the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSProfileFactory { 

    function getProfile(address _user) view external returns (address _profile);

    function getProfiles() view external returns (address [] memory _profiles);

    function createProfile(address _user) external returns (address _profile);

    function hasProfile(address _user) view external returns (bool _hasProfile);

    function isKnownProfile(address _address) view external returns (bool _isKnownProfile);

}