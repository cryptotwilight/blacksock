
// File: contracts/interfaces/module/IBKSModule.sol


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
// File: contracts/interfaces/module/IBKSMoneyModule.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Money Module 
  * @author cryptotwilight
  * @dev This is the Money Module that enables a user to create prices for various accesses to their Social Media such as sharing or advertising and enables a user to recieve, refund and withdraw payments.  
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

struct Payment {
    uint256 id; 
    string ref; 
    uint256 amount; 
    uint256 date; 
    address payee; 
    address payer;
    address paidBy; 
    address token; 
}

struct Price { 
    uint256 id; 
    string name; 
    uint256 amount; 
    address token;
}

interface IBKSMoneyModule is IBKSModule { 

    function getDefaultMoneyToken() view external returns (address _token);

    
    function getPriceNames() view external returns (string [] memory _priceNames);

    function hasPrice(string memory _priceName) view external returns (bool _hasPrice);

    function getPrice(string memory _priceName) view external returns (Price memory _price);

    function getPrices() view external returns (Price [] memory _price);

    function addPrice(Price memory _price) external returns (bool _added);
    
    function removePrice(string memory _name) external returns (Price memory _price);

    
    function getPayments() view external returns (Payment [] memory _payments);

    function getPayment(uint256 _pyamentId) view external returns (Payment memory _payment);

    function makePricedPayment(uint256 _priceId, address _payer) external payable returns (uint256 _paymentId);

    function makeRefPayment(string memory _ref, uint256 _amount, address _payer, address _token ) external payable returns (uint256 _paymentId);
    
    function makeRefund(uint256 _paymentId, string memory _reason) external returns (uint256 _refundPaymentId);

}
// File: contracts/interfaces/module/IBKSModuleRegister.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module Register
  * @author cryptotwilight
  * @dev This is the Module Register that is used to register an individual's modules in the Black Sock decentralized social protocol  
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSModuleRegister { 

    function getModule(uint256 _registrationId) view external returns (address _module);

    function getModules() view external returns (address [] memory _modules);

    function getModule(string memory _name) view external returns (address _module);

    function registerModule(address _module) external returns (uint256 _registrationId);

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
// File: contracts/interfaces/system/IBKSProfile.sol


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

// File: contracts/core/system/BKSProfile.sol


pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Profile
  * @author cryptotwilight
  * @dev This is the Profile implementation for the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

contract BKSProfile is IBKSProfile, IBKSProfileWriter, IBKSVersion { 

    string constant name = "BKS_PROFILE_NC"; 
    uint256 constant version = 1; 

    modifier ownerOnly {
        require(isOwner(), "owner only");
        _;
    }
    modifier adminOnly {
        require(adminEnabled && isAdmin(), "admin only");
        _;
    }

    modifier admin() {
        require((adminEnabled && isAdmin()) || isOwner() , " admin only ");
        _;
    }

    string constant BKS_ADMIN_CA = "BKS_ADMIN";
    IBKSOpsRegister register;
    IBKSModuleRegister moduleRegister; 
    Avatar avatar; 
    Price [] prices;

    address owner; 
    bool adminEnabled; 

    Notification [] notifications; 

    constructor(address _owner, address _register,  address _moduleRegister) {
        owner = _owner; 
        register = IBKSOpsRegister(_register);
        moduleRegister = IBKSModuleRegister(_moduleRegister);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getAvatar() view external returns (Avatar memory _avatar){
        return avatar; 
    }

    function getOwner() view external returns (address _owner) {
        return owner; 
    }

    function getModuleRegister() view external returns (address _moduleRegister){
        return address(moduleRegister);
    }

    function getPrices() view external returns (Price [] memory _price){
        return prices; 
    }

    function getNotifications() view external returns (Notification [] memory _notification){
        return notifications; 
    }

    function setUserAvatar(Avatar memory _avatar) external ownerOnly returns (bool _set) {
        avatar = _avatar; 
        return true; 
    }

    function notify(Notification memory _notification) external returns (bool _notified){
        notifications.push(_notification);
        return true; 
    }

    function enableAdmin() external ownerOnly returns (bool _adminEnabled) {
        adminEnabled = true; 
        return adminEnabled; 
    }

    //=================================== INTERNAL ==============================

    function isOwner() internal view returns (bool _isOwner) {
        return msg.sender == owner; 
    }

    function isAdmin() internal view returns (bool _isAdmin) {
        return msg.sender == register.getAddress(BKS_ADMIN_CA);
    }


}