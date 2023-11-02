// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module
  * @author cryptotwilight
  * @dev This is the Super interface for all Modules in the Black Sock decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSModule { 

    function getOwner() view external returns (address _user);

    function isAdminEnabled() view external returns (bool _isEnabled);

    function enableAdmin(bool _enable) external returns (bool _adminEnabled);

}