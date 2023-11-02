// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Rewards Service
  * @author cryptotwilight
  * @dev This is the service that is responsible for issuing rewards to the users of the decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSRewardsService { 

    function issueReward(address _owner, string memory _action) external returns (uint256 _rewardId);

}