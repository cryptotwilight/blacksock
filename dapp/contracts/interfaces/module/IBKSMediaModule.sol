// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Media Module 
  * @author cryptotwilight
  * @dev This is the Media Module used to manage and mint all of a user's media in the Black Sock Protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct Media {
    uint256 id; 
    string contentId; 
    string location; 
    string mediaType; 
    bool advertisingEnabled; 
    bool isMinted; 
}

struct PreUploadMedia {
    string contentId; 
    string location; 
    string mediaType; 
    bool advertisingEnabled;  
}

struct MediaShare { 
    uint256 id; 
    uint256 mediaId; 
    address [] users; 
    uint256 [] shareFeeSent; 
    bool [] success; 
    uint256 date; 
    uint256 successCount; 
}

interface IBKSMediaModule {

    function getMintedMediaSymbols() view external returns(string [] memory _mintedMediaSymbols);

    function getMintedMediaIds(string memory _symbol) view external returns (uint256 [] memory _mintedMediaIds);

    function getMintedMediaContract(string memory _symbol) view external returns (address _mintedMediaContract);

    function getMediaIds() view external returns (uint256 [] memory _mediaIds);

    function getMediaIdsByType(string memory _mediaType) view external returns (uint256 [] memory _mediaIds);

    function getMedia(uint256 _mediaId) view external returns (Media memory _media);

    function getPreUploadMedia(uint256 _mediaId) view external returns (PreUploadMedia memory _preUploadMedia);

    function postToStream(uint256 _mediaId) external returns (bool _posted);

    function uploadMedia(PreUploadMedia [] memory _media) external returns (uint256 [] memory _mediaIds);

    function deleteMedia(uint256 _mediaId) external returns (bool _deleted);

    function mintMedia(uint256 _mediaId, string memory _symbol) external returns (uint256 _nftId); 
    
    function burnMedia(uint256 _mediaId) external returns (uint256 _burnId);

    function createMintedMediaContract(string memory _name, string memory _symbol) external returns (address _mintedMediaContract);

    function mintToHolder(uint256 _mediaId, string memory _symbol, address _newHolder) external returns (uint256 _nftId);

    function shareOutbound(uint256 _mediaId, address [] memory _users, uint256 [] memory shareFeeSent) payable external returns (uint256 _shareId);

    function getMediaShare(uint256 _shareId) view external returns (MediaShare memory _share);

}