// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Minted Media Contract
  * @author cryptotwilight
  * @dev This is the minting interface used for converting media into NFTs in the Black Sock decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

interface IBKSMintedMediaContract { 

    function mint(uint256 _mediaId, address _to) external returns (uint256 _mintId);

    function burn(uint256 _mintId) external ;

}