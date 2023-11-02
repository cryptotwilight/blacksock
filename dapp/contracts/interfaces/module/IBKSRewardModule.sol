// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Reward Module & Writer 
  * @author cryptotwilight
  * @dev This is the Reward Module used to present the user with an accounting of the rewards recieved and the Writer to the modul that enables the user to recieve and cash out rewards
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct Reward {
    uint256 id; 
    string action; 
    uint256 date; 
    uint256 amount; 
    address token; 
}

struct RewardsCashOut {
    uint256 id; 
    uint256 date; 
    uint256 amount; 
}
interface IBKSRewardModule { 

    function getRewardsToken() view external returns (address _token);

    function getRewardsBalance() view external returns (uint256 _rewards);

    function getRewardStatement() view external returns (Reward [] memory _rewards);

    function getReward(uint256 _rewardId) view external returns (Reward memory _reward);

}

interface IBKSRewardModuleWriter {

    function recieveReward(string memory _action, uint256 _amount) external payable returns (uint256 _rewardId);

    function cashOutReward(uint256 _amount) external returns (uint256 _cashoutId);
}