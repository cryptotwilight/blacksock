// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Stream Module
  * @author cryptotwilight
  * @dev This is the Stream Module implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/system/IBKSDirectory.sol";

import "../../interfaces/module/IBKSPeopleModule.sol";
import "../../interfaces/module/IBKSStreamModule.sol";
import "../../interfaces/module/IBKSMoneyModule.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./BKSModule.sol";

contract BKSStreamModule is BKSModule, IBKSStreamModule {

    string constant vname = "BKS_STREAM_MODULE_NC";
    uint256 constant vversion = 1; 

    string constant BKS_DIRECTORY_CA = "BKS_DIRECTORY_CORE";

    string constant BKS_MONEY_MODULE_CA = "BKS_MONEY_MODULE_NC";
    string constant BKS_PEOPLE_MODULE_CA = "BKS_PEOPLE_MODULE_NC";
    

    uint256 constant UNIT_MAX = 10;

    uint256 [] streamWriteIds; 
    mapping(uint256=>StreamWrite) streamWriteById; 
    uint256 [] mediaIds; 
    uint256 [] postTimes; 
    uint256 [] mediaTypes;

    uint256 [] streamMediaIds; 
    mapping(uint256=>Media) mediaByMediaStreamId; 
    

    constructor(address _owner, address _opsRegister, address _moduleRegister) BKSModule(_owner, _opsRegister, _moduleRegister){
    }
    
    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getStreamWriteIds() view external returns (uint256 [] memory _ids){
        return streamWriteIds; 
    }

    function getStreamWrite(uint256 _streamWriteId) view external returns (StreamWrite memory _streamWrite){
        return streamWriteById[_streamWriteId];
    }

    function getStream() view external returns (uint256 [] memory _streamMediaIds, uint256 [] memory _postTime){
        return (streamMediaIds, postTimes);
    }

    function getStreamMedia(uint256 _streamMediaId) view external returns (Media memory _media){
        return mediaByMediaStreamId[_streamMediaId];
    }

    function writeToYourStream(Media memory _media, uint256 _feeSent) external payable returns (uint256 _streamWriteId){
        
        address owner_ = IBKSDirectory(register.getAddress(BKS_DIRECTORY_CA)).getAddressOwner(msg.sender);
        PersonStatus writerStatus_ = IBKSPeopleModule(mRegister.getModule(BKS_PEOPLE_MODULE_CA)).findPersonByAddress(owner_).status;
        require(writerStatus_ != PersonStatus.BLOCKED || writerStatus_ != PersonStatus.REMOVED, "write not allowed" );
        
        IBKSMoneyModule money_ = IBKSMoneyModule(mRegister.getModule(BKS_MONEY_MODULE_CA)); 
        require(money_.hasPrice(_media.mediaType), "write fail - no price specified");
        Price memory price_ = money_.getPrice(_media.mediaType);
        require(_feeSent >= price_.amount, "insufficient fee");
        uint256 paymentId_ = 0; 
        if(_feeSent > 0){
            IERC20(money_.getDefaultMoneyToken()).approve(address(money_), price_.amount);
            paymentId_ = money_.makePricedPayment(price_.id, owner_);
        }
        return postToStream(_media, price_.id, paymentId_);
    }

    function postToMyStream(Media memory _media) external ownerOnly returns (uint256 _streamWriteId){
        return postToStream(_media, 0,0); 
    }
    
    //========================================= INTERNAL ====================================================

    function postToStream(Media memory _media, uint256 _priceId, uint256 _paymentId) internal returns  (uint256 _streamWriteId) {
        _streamWriteId = getIndex(); 
        streamWriteIds.push(_streamWriteId);
        streamMediaIds.push(_streamWriteId);
        mediaByMediaStreamId[_streamWriteId] = _media; 
        mediaIds.push(_streamWriteId);
        postTimes.push(block.timestamp);
 
        streamWriteById[_streamWriteId] = StreamWrite({
                                                        id : _streamWriteId, 
                                                        mediaId :_media.id,
                                                        priceId : _priceId,
                                                        paymentId : _paymentId,  
                                                        writer : msg.sender,
                                                        date : block.timestamp
                                                    });
        return _streamWriteId; 
    }


}