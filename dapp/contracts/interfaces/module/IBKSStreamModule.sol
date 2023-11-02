// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Stream Module  
  * @author cryptotwilight
  * @dev This is the stream module that is used to present the user with a social media stream and enables advertisers to write to the user's stream for a fee set by the user
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./IBKSModule.sol";
import {Media} from "./IBKSMediaModule.sol";
import {Payment, Price} from "./IBKSMoneyModule.sol";

struct StreamWrite{
    uint256 id; 
    uint256 mediaId; 
    uint256 priceId; 
    uint256 paymentId;  
    address writer;
    uint256 date;   
}


interface IBKSStreamModule is IBKSModule { 

        function getStreamWriteIds() view external returns (uint256 [] memory _ids);

        function getStreamWrite(uint256 _streamWriteId) view external returns (StreamWrite memory _streamWrite);

        function getStream() view external returns (uint256 [] memory _mediaId, uint256 [] memory _postTime); 

        function getStreamMedia(uint256 _mediaId) view external returns (Media memory _media);

        function writeToYourStream(Media memory _media, uint256 _feeSent) external payable returns (uint256 _streamWriteId);

        function postToMyStream(Media memory _media) external returns (uint256 _streamWriteId);
}