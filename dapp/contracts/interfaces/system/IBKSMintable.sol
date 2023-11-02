// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Mintabble
  * @author cryptotwilight
  * @dev This is the minting interface for ERC20 fungible tokens used in the Black Sock protocol 
  * @custom:buidl'd at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct MintRecord { 
    uint256 id; 
    address mintedBy; 
    address mintedTo; 
    uint256 amount; 
    uint256 date; 
}

interface IBKSMintable { 

    function getMintRecordIds() view external returns (uint256 [] memory _mintRecordIds);

    function getMintRecord(uint256 _mintId) view external returns (MintRecord memory _mint);

    function mint(address to_, uint256 _amount) external returns (uint256 _mintId);

}