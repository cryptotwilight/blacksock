// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Factory
  * @author cryptotwilight
  * @dev This is the Factory super contract implementation the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/system/IBKSOpsRegister.sol";
import "../../interfaces/system/IBKSVersion.sol";
import "../../interfaces/system/IBKSDirectory.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract BKSFactory is IBKSVersion { 

    using Strings for address; 

    modifier systemOnly() {
        require(register.isSystemAddress(msg.sender), string.concat( "system only :x: ", msg.sender.toHexString()));
        _;
    }

    modifier adminOnly() { 
        require(msg.sender == register.getAddress(BKS_ADMIN_CA),string.concat( "admin only :x: ", msg.sender.toHexString()));
        _;
    }

    string constant BKS_DIRECTORY_CA = "BKS_DIRECTORY_CORE";
    string constant BKS_ADMIN_CA = "BKS_ADMIN";
    string constant BLACK_SOCK_CA = "BLACK_SOCK_CORE";

    IBKSOpsRegister register; 

    constructor(address _opsRegister) { 
        register = IBKSOpsRegister(_opsRegister);
    }

    function registerAddressWithDirectory(address _address, address _owner) internal {
        IBKSDirectory(register.getAddress(BKS_DIRECTORY_CA)).addBKSAddress(_address,_owner);
    }
}