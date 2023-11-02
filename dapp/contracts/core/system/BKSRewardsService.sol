// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Reward Service 
  * @author cryptotwilight
  * @dev This is the implementation contract for the Reward Service the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/system/IBKSRewardsService.sol";
import "../../interfaces/system/IBKSProfileRegister.sol"; 
import "../../interfaces/system/IBKSProfile.sol"; 
import "../../interfaces/system/IBKSMintable.sol"; 

import "../../interfaces/module/IBKSRewardModule.sol";
import "../../interfaces/module/IBKSModuleRegister.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./BKSSystemContract.sol";

contract BKSRewardService is BKSSystemContract, IBKSRewardsService { 

    string constant name = "BKS_REWARD_SERVICE_CORE";
    uint256 constant version = 1; 

    string constant PROFILE_REWARD_MODULE_CA = "REWARD_MODULE_NC";
    string constant REWARD_TOKEN_CA = "BKS_REWARD_TOKEN_CORE";
    string constant PROFILE_REGISTER_CA = "PROFILE_REGISTER";

    address self; 

    string [] actions; 
    mapping(address=>uint256[]) rewardIdByOwner; 
    mapping(string=>uint256) rewardByAction; 
    mapping(address=>mapping(uint256=>uint256)) rewardByIdByOwner; 
    
    constructor(address _register) BKSSystemContract(_register) {
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getRewardedActions() view external returns (string [] memory _actions) {
        return actions; 
    }

    function getRewardsForOwner(address _owner) view external returns (uint256 [] memory _rewards){
        return rewardIdByOwner[_owner];
    }

    function getRewardByIdByOwner(address _owner, uint256 _rewardId) view external returns (uint256 _amount) {
        return rewardByIdByOwner[_owner][_rewardId]; 
    }

    function issueReward(address _owner, string memory _action) external bksOnly returns (uint256 _rewardId){
        IBKSRewardModuleWriter rewardModule_ = IBKSRewardModuleWriter(IBKSModuleRegister(IBKSProfile(IBKSProfileRegister(register.getAddress(PROFILE_REGISTER_CA)).findProfileByOwner(_owner)).getModuleRegister()).getModule(PROFILE_REWARD_MODULE_CA));
        uint256 rewardAmount_ = rewardByAction[_action]; 
        if(rewardAmount_ == 0){
            return 0;
        }
        IBKSMintable(register.getAddress(REWARD_TOKEN_CA)).mint(self, rewardAmount_);
        IERC20(register.getAddress(REWARD_TOKEN_CA)).approve(address(rewardModule_), rewardAmount_);
        _rewardId = rewardModule_.recieveReward(_action, rewardAmount_);
        rewardIdByOwner[_owner].push(_rewardId);
        return _rewardId; 
    }

    function setRewardForAction(string memory _action, uint256 _amount) external adminOnly returns (bool _set) {
        rewardByAction[_action] = _amount; 
        return true;
    }
}