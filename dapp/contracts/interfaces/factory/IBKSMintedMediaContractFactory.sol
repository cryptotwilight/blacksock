// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Minted Media Contract Factory 
  * @author cryptotwilight
  * @dev This is the factory used to create Minted Media Contracts for users in the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

interface IBKSMintedMediaContractFactory { 

    function createMintedMediaContract(string memory _name, string memory _symbol) external returns (address _mintedMediaContract);

}