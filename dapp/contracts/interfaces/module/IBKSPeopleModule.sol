// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - People Module 
  * @author cryptotwilight
  * @dev This is the People Module that enables the user to create their decentralized social network in the Black Sock decentralized protocol. It enables them to moderate and tag their community
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./IBKSModule.sol";

enum PersonStatus {ACTIVE, BLOCKED, PROMOTED, DEMOTED, IGNORED, REMOVED}

enum MODERATE_PERSON{BLOCK, UNBLOCK, PROMOTE, DEMOTE, IGNORE}

struct Person { 
    uint256 id; 
    string name; 
    address wallet; 
    address profile; 
    string [] tags; 
    uint256 createDate; 
    PersonStatus status; 
}

interface IBKSPeopleModule is IBKSModule { 

    function getPeople() view external returns (uint256 [] memory _personId);

    function getPersonById(uint256 id) view external returns (Person memory _person);

    function findPeopleByTag (string memory _tag) view external returns (uint256 [] memory _personId);

    function findPeopleByName(string memory _name) view external returns (uint256 [] memory _personId);

    function findPersonByAddress(address _user) view external returns (Person memory _person);

    function getPeopleByPersonStatus(PersonStatus _personStatus) view external returns (uint256 [] memory _personId);

    function moderatePerson (address _user, MODERATE_PERSON _action) external returns (bool _actioned);

    function addPerson(string memory _name, address _user, string [] memory _tags) external returns (Person memory _person);

    function removePerson(address _user) external returns (Person memory _removed);
}