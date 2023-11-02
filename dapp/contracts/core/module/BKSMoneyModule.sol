// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Money Module
  * @author cryptotwilight
  * @dev This is the Module implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

import "../../interfaces/module/IBKSMoneyModule.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./BKSModule.sol";


contract BKSMoneyModule is BKSModule, IBKSMoneyModule {

    string constant vname = "BKS_MONEY_MODULE_NC";
    uint256 constant vversion = 1; 

    uint256 constant UNIT_MAX = 10;
    string constant DEFAULT_TOKEN_CA = "DEFAULT_TOKEN";
    address self; 

    string constant WITHDRAWAL_REF = "WITHDRAWAL";
    string constant REFUND_REF = "REFUND - ";

    string [] priceNames; 
    mapping(string=>bool) hasPriceByPriceName; 
    mapping(string=>Price) priceByName;
    mapping(uint256=>Price) priceById; 

    uint256 [] paymentIds; 
    mapping(uint256=>Payment) paymentById; 

    constructor(address _owner, address _opsRegister, address _moduleRegister)BKSModule(_owner, _opsRegister, _moduleRegister){
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getDefaultMoneyToken() view external returns (address _token){
        return register.getAddress(DEFAULT_TOKEN_CA);
    }
    
    function getPriceNames() view external returns (string [] memory _priceNames){
        return priceNames; 
    }

    function hasPrice(string memory _priceName) view external returns (bool _hasPrice) {
        return hasPriceByPriceName[_priceName];
    }

    function getPrice(string memory _priceName) view external returns (Price memory _price){
        return priceByName[_priceName];
    }

    function getPrices() view external  returns (Price [] memory _price){
        _price = new Price[](priceNames.length);
        for(uint256 x = 0; x < priceNames.length; x++) {
            _price[x] = priceByName[priceNames[x]];
        }
        return _price; 
    }

    function addPrice(Price memory _price) external adminOnly returns (bool _added){
        priceByName[_price.name] = Price({
                                            id : getIndex(),
                                            name : _price.name, 
                                            amount : _price.amount,
                                            token : _price.token
                                        }); 
        priceNames.push(_price.name);
        return true; 
    }
    
    function removePrice(string memory _name) external adminOnly returns (Price memory _price){
        _price = priceByName[_name];
        delete priceByName[_name];
        return _price; 
    }

    function getPayments() view external returns (Payment [] memory _payments){
        _payments = new Payment[](paymentIds.length);
        for(uint256 x = 0; x < paymentIds.length; x++) {
            _payments[x] = paymentById[paymentIds[x]];
        }
        return _payments; 
    }

    function getPayment(uint256 _paymentId) view external returns (Payment memory _payment){
        return paymentById[_paymentId];
    }

    function makePricedPayment(uint256 _priceId, address _payer) external payable returns (uint256 _paymentId){
        Price memory price_ = priceById[_priceId];
        return processPayment(price_.amount, self, _payer, msg.sender, price_.token, price_.name);
    }

    function makeRefPayment(string memory _ref, uint256 _amount, address _payer, address _token ) external payable returns (uint256 _paymentId){
        return processPayment(_amount, self, _payer, msg.sender, _token, _ref);
    }
    
    function makeRefund(uint256 _paymentId, string memory _reason) external adminOnly returns (uint256 _rPaymentId){
        Payment memory payment_ = paymentById[_paymentId];
        return processPayment(payment_.amount, payment_.payer, payment_.payee, self, payment_.token, string.concat(REFUND_REF, (string.concat(string.concat(_reason," - "),(payment_.ref)))));
    }


    function withdrawFunds(uint256 _amount, address _token) external ownerOnly returns (uint256 _paymentId) {
        return processPayment(_amount, msg.sender,  self, self,_token, WITHDRAWAL_REF );
    }

    //============================== INTERNAL ==========================================

    function processPayment(uint256 _amount,  address _payee, address _payer, address _paidBy,  address _token, string memory _ref ) internal returns (uint256 _paymentId ){
        _paymentId = getIndex(); 
        IERC20(_token).transferFrom(_paidBy, _payee, _amount);
        paymentIds.push(_paymentId);
        paymentById[_paymentId] = Payment({
                                        id      : _paymentId, 
                                        ref     : _ref, 
                                        amount  : _amount, 
                                        date    : block.timestamp,
                                        payee   : _payee,  
                                        payer   : _payer, 
                                        paidBy  : _paidBy, 
                                        token   : _token
                                    });
        return _paymentId; 
    }
}