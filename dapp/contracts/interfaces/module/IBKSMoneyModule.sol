// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Money Module 
  * @author cryptotwilight
  * @dev This is the Money Module that enables a user to create prices for various accesses to their Social Media such as sharing or advertising and enables a user to recieve, refund and withdraw payments.  
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./IBKSModule.sol";

struct Payment {
    uint256 id; 
    string ref; 
    uint256 amount; 
    uint256 date; 
    address payee; 
    address payer;
    address paidBy; 
    address token; 
}

struct Price { 
    uint256 id; 
    string name; 
    uint256 amount; 
    address token;
}

interface IBKSMoneyModule is IBKSModule { 

    function getDefaultMoneyToken() view external returns (address _token);

    
    function getPriceNames() view external returns (string [] memory _priceNames);

    function hasPrice(string memory _priceName) view external returns (bool _hasPrice);

    function getPrice(string memory _priceName) view external returns (Price memory _price);

    function getPrices() view external returns (Price [] memory _price);

    function addPrice(Price memory _price) external returns (bool _added);
    
    function removePrice(string memory _name) external returns (Price memory _price);

    
    function getPayments() view external returns (Payment [] memory _payments);

    function getPayment(uint256 _pyamentId) view external returns (Payment memory _payment);

    function makePricedPayment(uint256 _priceId, address _payer) external payable returns (uint256 _paymentId);

    function makeRefPayment(string memory _ref, uint256 _amount, address _payer, address _token ) external payable returns (uint256 _paymentId);
    
    function makeRefund(uint256 _paymentId, string memory _reason) external returns (uint256 _refundPaymentId);

}