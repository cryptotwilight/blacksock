// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Profile & Profile Writer
  * @author cryptotwilight
  * @dev This is the interface specification for an individual's Black Sock profile in the decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct Avatar { 
    string name; 
    string image; 
}

struct Notification {
    uint256 id; 
    string notificationType; 
    uint256 date; 
    string content; 
}

interface IBKSProfile {

    function getAvatar() view external returns (Avatar memory _avatar);

    function getOwner() view external returns (address _owner);

    function getModuleRegister() view external returns (address _moduleRegister);

    function getNotifications() view external returns (Notification [] memory _notification);

}

interface IBKSProfileWriter{

    function setUserAvatar(Avatar memory _avatar) external returns (bool _set);

    function notify(Notification memory _notification) external returns (bool _notified);

}
