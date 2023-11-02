// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Reward Module 
  * @author cryptotwilight
  * @dev This is the Reward Module implementation for the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/module/IBKSRewardModule.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./BKSModule.sol";


contract BKSRewardModule is BKSModule, IBKSRewardModule, IBKSRewardModuleWriter {

    string constant vname = "BKS_STREAM_MODULE_NC";
    uint256 constant vversion = 1; 

    uint256 constant UNIT_MAX = 10;

    string constant REWARDS_TOKEN_CA = "BKS_REWARD_TOKEN_CORE";

    address self; 

    uint256 rewardsBalance; 
    uint256 [] rewardIds; 
    mapping(uint256=>Reward) rewardById;
    mapping(uint256=>RewardsCashOut) rewardsCashOutById; 

    constructor(address _owner, address _opsRegister, address _moduleRegister)BKSModule(_owner, _opsRegister, _moduleRegister){
        self = address(this);
    }
    
    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getRewardsToken() view external returns (address _token){
        return register.getAddress(REWARDS_TOKEN_CA);
    }

    function getRewardsBalance() view external returns (uint256 _rewards){
        return rewardsBalance; 
    }

    function getRewardStatement() view external returns (Reward [] memory _rewards){
        for(uint256 x = 0; x < rewardIds.length; x++) {
            _rewards[x] = rewardById[rewardIds[x]];
        }
        return _rewards; 
    }

    function getReward(uint256 _rewardId) view external returns (Reward memory _reward){
        return rewardById[_rewardId];
    }

    function recieveReward(string memory _action, uint256 _amount) external payable returns (uint256 _rewardId){
        rewardsBalance += _amount; 
        _rewardId = getIndex();
        IERC20(register.getAddress(REWARDS_TOKEN_CA)).transferFrom(msg.sender, self, _amount);
        rewardById[_rewardId] = Reward ({
                                            id : _rewardId, 
                                            action : _action,
                                            date : block.timestamp, 
                                            amount : _amount,
                                            token : register.getAddress(REWARDS_TOKEN_CA)
                                      });
    }

    function cashOutReward(uint256 _amount) external ownerOnly returns (uint256 _cashoutId){
        rewardsBalance -= _amount; 
        IERC20(register.getAddress(REWARDS_TOKEN_CA)).transferFrom(self, owner, _amount);
        _cashoutId = getIndex(); 
        rewardsCashOutById[_cashoutId] = RewardsCashOut ({
                                                            id : _cashoutId, 
                                                            date : block.timestamp, 
                                                            amount : _amount
                                                        });
        return _cashoutId; 
    }


}