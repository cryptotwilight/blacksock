// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
 /**
  * @title Black Sock - Reward Token 
  * @author cryptotwilight
  * @dev This is the this is the fungible Reward Token used in the Black Sock decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../../interfaces/system/IBKSMintable.sol";
import "./BKSSystemContract.sol";

contract BKSRewardToken is BKSSystemContract, ERC20, IBKSMintable {

    string constant vname = "BKS_REWARD_TOKEN_CORE";
    uint256 constant version = 1; 

    uint256 [] mintRecordIds; 
    mapping(uint256=>MintRecord) mintRecordById; 

    constructor(address _opsRegister, string memory _name, string memory _symbol) 
        BKSSystemContract(_opsRegister)
        ERC20(_name, _symbol) {}

    function getName() pure external returns (string memory _name) {
        return vname; 
    }

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }
    function getMintRecordIds() view external returns (uint256 [] memory _mintRecordIds){
        return mintRecordIds; 
    }

    function getMintRecord(uint256 _mintId) view external returns (MintRecord memory _mint){
        return mintRecordById[_mintId];
    }

    function mint(address to_, uint256 _amount) external bksOnly returns (uint256 _mintId){
        _mint(to_, _amount);
        _mintId = getIndex(); 
        mintRecordIds.push(_mintId);
        mintRecordById[_mintId] = MintRecord({
                                                id : _mintId,  
                                                mintedBy  : msg.sender,  
                                                mintedTo  : to_,
                                                amount : _amount, 
                                                date : block.timestamp
                                            });
        return _mintId; 
    }
}
 