// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - System Contract
  * @author cryptotwilight
  * @dev This is the super contract for system contracts in the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/system/IBKSVersion.sol";
import "../../interfaces/system/IBKSOpsRegister.sol";
import "../../interfaces/system/IBKSDirectory.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract BKSSystemContract is IBKSVersion { 

    using Strings for address; 

    string constant BKS_DIRECTORY_CA = "BKS_DIRECTORY_CORE";
    string constant BKS_ADMIN_CA = "BKS_ADMIN";

    uint256 index; 

    modifier systemOnly() {
        require(register.isSystemAddress(msg.sender),string.concat("system only x  :x: ",msg.sender.toHexString()));
        _;
    }

    modifier adminOnly() { 
        require(msg.sender == register.getAddress(BKS_ADMIN_CA),string.concat("admin only x  :x: ",msg.sender.toHexString()));
        _;
    }

    modifier bksOnly() { 
        require (IBKSDirectory(register.getAddress(BKS_DIRECTORY_CA)).isBKSAddress(msg.sender), string.concat("unknown bks address :x: ",msg.sender.toHexString()));
        _;
    }

    IBKSOpsRegister register; 

    constructor(address _opsRegister) {
        register = IBKSOpsRegister(_opsRegister);
    }

    //========================== INTERNAL =======================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

}