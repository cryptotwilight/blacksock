// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Minted Media Contract Factory 
  * @author cryptotwilight
  * @dev This is the Minted Media Contract Factory implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "../../interfaces/factory/IBKSMintedMediaContractFactory.sol";
import "../../interfaces/factory/IBKSMediaModuleFactory.sol";

import "../module/BKSMintedMediaContract.sol";

import "./BKSFactory.sol";

contract BKSMintedMediaContractFactory is BKSFactory, IBKSMintedMediaContractFactory { 

    string constant name = "BKS_MINTED_MEDIA_CONTRACT_FACTORY_CORE";
    uint256 constant version = 1; 

    string constant MEDIA_MODULE_FACTORY_CA = "BKS_MEDIA_MODULE_FACTORY_CORE";

    address []  mintedMediaContracts; 
    mapping(address=>bool) hasMintedMediaContracts; 
    mapping(address=>address[]) mintedMediaContractsByOwner;
    mapping(address=>bool) isKnownMMContract; 
    mapping(string=>bool) knownSymbol; 

    constructor(address _opsRegister) BKSFactory(_opsRegister) {        
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getMintedMediaContracts() view external returns (address [] memory _contacts) {
        return mintedMediaContracts; 
    }

    function isKnownMintedMediaContract(address _mintedMediaContract) view external returns (bool _isKnown) {
        return  isKnownMMContract[_mintedMediaContract];
    }

    function getMintedMediaContracts(address _owner) view external returns (address [] memory _mintedMediaContract) {
        if(hasMintedMediaContracts[_owner]){
            return mintedMediaContractsByOwner[_owner];
        }
        return new address[](0);
    }

    function createMintedMediaContract(string memory _name, string memory _symbol) external returns (address _mintedMediaContract){
        require(IBKSMediaModuleFactory(register.getAddress(MEDIA_MODULE_FACTORY_CA)).isKnownMediaModule(msg.sender),"unknown module");
        require(!knownSymbol[_symbol],"known symbol");
        knownSymbol[_symbol] = true; 

        _mintedMediaContract = address(new BKSMintedMediaContract(_name, _symbol, msg.sender));

        isKnownMMContract[_mintedMediaContract] = true; 
        IBKSMediaModule mediaModule_ = IBKSMediaModule(msg.sender);
        address owner_ =IBKSModule(address(mediaModule_)).getOwner(); 

        

        mintedMediaContractsByOwner[owner_].push(_mintedMediaContract);
        hasMintedMediaContracts[owner_] = true; 
        registerAddressWithDirectory(_mintedMediaContract, owner_);

        return _mintedMediaContract; 
    }

}