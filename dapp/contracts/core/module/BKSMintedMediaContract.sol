// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Minted Media Contract 
  * @author cryptotwilight
  * @dev This is the Minted Media Contract implementation the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

import "../../interfaces/module/IBKSMintedMediaContract.sol";
import "../../interfaces/module/IBKSMediaModule.sol";
import "../../interfaces/module/IBKSModule.sol";

contract BKSMintedMediaContract is ERC721, ERC721Burnable, IBKSMintedMediaContract { 

    modifier ownerOnly {
        require(isOwner(), "owner only");
        _;
    }

    uint256 index; 
    mapping(uint256=>string) uriByMintId;
    mapping(uint256=>bool) knownTokenId; 
    mapping(uint256=>uint256) mediaIdByMintId;
    mapping(uint256=>uint256) mintIdByMediaId; 
    IBKSMediaModule mediaModule; 

    constructor(string memory _name, string memory _symbol, address _mediaModule) ERC721(_name, _symbol){
        mediaModule = IBKSMediaModule(_mediaModule);
    }


    function tokenURI(uint256 tokenId) public view override returns (string memory){
        require(knownTokenId[tokenId],"unknown token");
        return uriByMintId[tokenId];
    }

    function mint(uint256 _mediaId, address _to) external ownerOnly returns (uint256 _mintId) {
        Media memory media_ = mediaModule.getMedia(_mediaId);
        _mintId = getIndex(); 
        _mint(_to, _mintId);
        uriByMintId[_mintId] = media_.location; 
        mediaIdByMintId[_mintId] = _mediaId; 
        mintIdByMediaId[_mediaId] = _mintId; 
        return _mintId; 
    }   

    function burn(uint256 _mintId) override (ERC721Burnable, IBKSMintedMediaContract) public {
        require(ownerOf(_mintId) == msg.sender, "owner only");
        _burn(_mintId);
    }

    //============================================= INTERNAL ============================

    function isOwner() internal view returns (bool _isOwner) {
        return (msg.sender == IBKSModule(address(mediaModule)).getOwner()); 
    }

    function getIndex() internal returns (uint256 _index) { 
        _index = index++;
        return _index; 
    }
}