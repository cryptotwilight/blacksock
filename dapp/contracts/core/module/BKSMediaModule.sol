// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Media Module  
  * @author cryptotwilight
  * @dev This is the Media Module implementation the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSModule.sol";
import "../../interfaces/module/IBKSMediaModule.sol";
import "../../interfaces/module/IBKSStreamModule.sol";
import "../../interfaces/module/IBKSModuleRegister.sol";
import "../../interfaces/factory/IBKSMintedMediaContractFactory.sol";

import "../../interfaces/module/IBKSMintedMediaContract.sol";
import "../../interfaces/IBlackSock.sol";
import "../../interfaces/system/IBKSProfile.sol";

contract BKSMediaModule is BKSModule, IBKSMediaModule { 

    string constant vname = "BKS_MEDIA_MODULE_NC";
    uint256 constant vversion = 1; 

    uint256 constant UNIT_MAX = 10;

    string constant MINTED_MEDIA_CONTRACT_FACTORY_CA = "BKS_MINTED_MEDIA_CONTRACT_FACTORY_CORE";

    string constant STREAM_MODULE_CA = "BKS_STREAM_MODULE_NC";

    mapping(string=>address) mintedMediaContractBySymbol; 
    mapping(string=>bool) knownSymbol; 

    uint256 [] mediaIds;
    mapping(uint256=>bool) knownMediaId; 
    mapping(uint256=>Media) mediaById; 
    mapping(uint256=>PreUploadMedia) preUploadMediaByMediaId;
    mapping(string=>uint256[]) mediaIdsByType;  

    string [] mintedMediaSymbols; 
    mapping(string=>uint256[]) mintedMediaIdsBySymbol; 
    mapping(string=>uint256[]) mintedMediaIdsByType;
    mapping(uint256=>uint256) nftByMediaId;
    mapping(string=>mapping(uint256=>uint256)) nftByMediaIdBySymbol; 
    mapping(uint256=>mapping(string=>uint256)) nftBySymbolByMediaId;
    mapping(uint256=>string) symbolByMediaId; 
    mapping(uint256=>uint256) burnIdByNft;
    mapping(uint256=>bool) isBurntByNft; 
    
    uint256 [] mediaShareIds;
    mapping(uint256=>MediaShare) mediaShareById; 
 
    IBKSModuleRegister moduleRegister; 

    constructor (address _owner, address _opsRegister, address _moduleRegister) BKSModule(_owner, _opsRegister, _moduleRegister){       
        moduleRegister = IBKSModuleRegister(_moduleRegister);
    }

    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getMintedMediaSymbols() view external returns(string [] memory _mintedMediaSymbols){
        return mintedMediaSymbols; 
    }   

    function getMintedMediaIds(string memory _symbol) view external returns (uint256 [] memory _mintedMediaIds){
        return mintedMediaIdsBySymbol[_symbol];
    }

    function getMintedMediaContract(string memory _symbol) view external returns (address _mintedMediaContract){
        return mintedMediaContractBySymbol[_symbol];
    }

    function getMediaIds() view external returns (uint256 [] memory _mediaIds){
        return mediaIds; 
    }

    function getMediaIdsByType(string memory _mediaType) view external returns (uint256 [] memory _mediaIds){
        return mintedMediaIdsByType[_mediaType];
    }

    function getMedia(uint256 _mediaId) view external returns (Media memory _media){
        return mediaById[_mediaId];
    }

    function getPreUploadMedia(uint256 _mediaId) view external returns (PreUploadMedia memory _preUploadMedia){
        return preUploadMediaByMediaId[_mediaId];
    }

    function postToStream(uint256 _mediaId) external ownerOnly rewarded ("POST") returns (bool _posted){
        require(knownMediaId[_mediaId], "unknown media id");
        IBKSStreamModule stream_ = IBKSStreamModule(moduleRegister.getModule(STREAM_MODULE_CA));
        stream_.postToMyStream(mediaById[_mediaId]);
        return true; 
    }

    function uploadMedia(PreUploadMedia [] memory _media) external ownerOnly returns (uint256 [] memory _mediaIds){
        require(_media.length <= UNIT_MAX, "max upload exceeded");
        _mediaIds = new uint256[](_media.length);
        for(uint256 x =0; x < _media.length; x++) {
            _mediaIds[x] = createMedia(_media[x]);
        }
        return _mediaIds;
    }

    function deleteMedia(uint256 _mediaId) external ownerOnly returns (bool _deleted){
        require(knownMediaId[_mediaId], "unknown media id");
        delete preUploadMediaByMediaId[_mediaId];
        delete mediaById[_mediaId];
        delete knownMediaId[_mediaId];
        return true; 
    }

    function mintMedia(uint256 _mediaId, string memory _symbol) external ownerOnly rewarded("MINT") returns (uint256 _nftId){
        return mint(_mediaId, _symbol, owner);
    }
    
    function burnMedia(uint256 _mediaId) external ownerOnly returns (uint256 _burnId){
        string memory symbol_ = symbolByMediaId[_mediaId];
        _burnId = getIndex(); 
        IBKSMintedMediaContract( mintedMediaContractBySymbol[symbol_]).burn(nftByMediaId[_mediaId]);
        burnIdByNft[_burnId] = nftByMediaId[_mediaId];
        return _burnId; 
    }

    function createMintedMediaContract(string memory _name, string memory _symbol) external ownerOnly returns (address _mintedMediaContract) {
        require(!knownSymbol[_symbol], "symbol already used");
        knownSymbol[_symbol] = true; 
        mintedMediaSymbols.push(_symbol);
        IBKSMintedMediaContractFactory factory  = IBKSMintedMediaContractFactory(register.getAddress(MINTED_MEDIA_CONTRACT_FACTORY_CA));
        _mintedMediaContract                    = factory.createMintedMediaContract(_name, _symbol);
        mintedMediaContractBySymbol[_symbol]    = _mintedMediaContract; 
        return _mintedMediaContract; 
    }

    function mintToHolder(uint256 _mediaId, string memory _symbol, address _newHolder) external ownerOnly rewarded("MINT_TO_HOLDER") returns (uint256 _nftId){
        return mint(_mediaId, _symbol, _newHolder); 
    }

    function shareOutbound(uint256 _mediaId, address [] memory _users, uint256 [] memory _shareFeeSent) payable ownerOnly rewarded("SHARE") external returns (uint256 _shareId){
        require(_users.length <= UNIT_MAX, "too many users");
        bool [] memory success_ = new bool[](_users.length);
        uint256 successCount_ = 0; 
        for( uint256 x = 0; x < _users.length; x++){
            if(shareToUser(_mediaId, _users[x], _shareFeeSent[x])){
                successCount_++;
            }
        }
        _shareId = getIndex();
        mediaShareById[_shareId] = MediaShare({
                                                id : _shareId, 
                                                mediaId : _mediaId, 
                                                users : _users,
                                                shareFeeSent : _shareFeeSent,
                                                success : success_,
                                                date : block.timestamp,
                                                successCount : successCount_
                                            });
        return _shareId; 
    }

    function getMediaShareIds()  view external returns (uint256 [] memory _mediaShareIds) {
        return mediaShareIds;
    }

    function getMediaShare(uint256 _shareId) view external returns (MediaShare memory _share){
        return mediaShareById[_shareId];
    }

    //===================================== INTERNAL ========================================

    function shareToUser(uint256 _mediaId, address _user, uint256 _feeSent) internal returns (bool _shared) {
        IBlackSock blackSock_ = IBlackSock(register.getAddress(BLACK_SOCK_CA));
        address result_ = blackSock_.findProfile(_user); 
        if(result_ == address(0)){
            return false; 
        }
        IBKSProfile profile_ = IBKSProfile(result_);
        IBKSStreamModule stream_ = IBKSStreamModule(IBKSModuleRegister(profile_.getModuleRegister()).getModule(STREAM_MODULE_CA));
        stream_.writeToYourStream(mediaById[_mediaId], _feeSent);
        return true; 
    }

    function mint(uint256 _mediaId, string memory _symbol, address _newHolder) internal returns (uint256 _nftId) {
        require(knownSymbol[_symbol], "unknown collection");
        require(!mediaById[_mediaId].isMinted, "media already minted");
        mediaById[_mediaId].isMinted = true; 
        _nftId = IBKSMintedMediaContract( mintedMediaContractBySymbol[_symbol] ).mint(_mediaId, _newHolder);
        nftByMediaId[_mediaId] = _nftId; 
        nftByMediaIdBySymbol[_symbol][_mediaId] = _nftId; 
        nftBySymbolByMediaId[_mediaId][_symbol] = _nftId; 
        mintedMediaIdsBySymbol[_symbol].push(_mediaId);
        mintedMediaIdsByType[mediaById[_mediaId].mediaType].push(_mediaId);
        symbolByMediaId[_mediaId] = _symbol; 
        return _nftId; 
    }

    function createMedia(PreUploadMedia memory _pMedia) internal returns ( uint256 _mediaId) {
        _mediaId = getIndex(); 
        knownMediaId[_mediaId] = true;
        mediaIds.push(_mediaId);
        preUploadMediaByMediaId[_mediaId] = _pMedia;
        mediaById[_mediaId] =  Media({
                                        id : _mediaId,
                                        contentId : _pMedia.contentId,
                                        location : _pMedia.location,
                                        mediaType : _pMedia.mediaType,
                                        advertisingEnabled : _pMedia.advertisingEnabled,
                                        isMinted : false 
                                    });
        mediaIdsByType[_pMedia.mediaType].push(_mediaId);
        return _mediaId;
    }
}