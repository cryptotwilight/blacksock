// SPDX-License-Identifier: APACHE 2.0
pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - People Module 
  * @author cryptotwilight
  * @dev This is the People Module implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
import "./BKSModule.sol";

import "../../interfaces/module/IBKSPeopleModule.sol";


contract BKSPeopleModule is BKSModule, IBKSPeopleModule {

    string constant vname = "BKS_STREAM_MODULE_NC";
    uint256 constant vversion = 1; 

    uint256 constant UNIT_MAX = 10;

    uint256 [] peopleIds; 
    mapping(uint256=>bool) activeByPersonId;
    
    mapping(uint256=>Person) personById;
    mapping(address=>uint256) personIdByAddress; 
    mapping(string=>uint256[]) peopleByTag;
    mapping(string=>uint256[]) peopleByName;
    mapping(PersonStatus=>uint256[]) peopleByStatus;    

    constructor(address _owner, address _opsRegister, address _moduleRegister)BKSModule(_owner, _opsRegister, _moduleRegister){
    }
    
    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getPeople() view external returns (uint256 [] memory _personId){
        return peopleIds; 
    }

    function getPersonById(uint256 _id) view external returns (Person memory _person){
        return personById[_id];
    }

    function findPeopleByTag (string memory _tag) view external returns (uint256 [] memory _personId){
        return peopleByTag[_tag];
    }

    function findPeopleByName(string memory _name) view external returns (uint256 [] memory _personId){
        return peopleByName[_name];
    }

    function findPersonByAddress(address _user) view external returns (Person memory _person){
        return personById[personIdByAddress[_user]];
    }

    function getPeopleByPersonStatus(PersonStatus _personStatus) view external returns (uint256 [] memory _personId){
        return peopleByStatus[_personStatus];
    }

    function moderatePerson (address _user, MODERATE_PERSON _action) external returns (bool _actioned){

        uint256 id_ = personIdByAddress[_user];
        if(MODERATE_PERSON.BLOCK == _action) {
            personById[id_].status = PersonStatus.BLOCKED;
        }

        if(MODERATE_PERSON.UNBLOCK == _action) {
            personById[id_].status = PersonStatus.ACTIVE;
        }

        if(MODERATE_PERSON.PROMOTE == _action) {
                if(personById[id_].status == PersonStatus.DEMOTED){
                personById[id_].status = PersonStatus.ACTIVE;
                return true; 
            }
            personById[id_].status = PersonStatus.PROMOTED;
        }

        if(MODERATE_PERSON.DEMOTE == _action) {
            if(personById[id_].status == PersonStatus.PROMOTED){
                personById[id_].status = PersonStatus.ACTIVE;
                return true; 
            }
            personById[id_].status = PersonStatus.DEMOTED;
        }

        if(MODERATE_PERSON.IGNORE == _action) {
            personById[id_].status = PersonStatus.IGNORED;
        }
        return true; 
    }

    function addPerson(string memory _name, address _user, string [] memory _tags) external returns (Person memory _person){
        uint256 id_ = getIndex(); 
        personById[id_] = Person({  
                                    id : id_,
                                    name : _name, 
                                    wallet : _user, 
                                    profile : IBlackSock(register.getAddress(BLACK_SOCK_CA)).findProfile(_user), 
                                    tags : _tags,  
                                    createDate  : block.timestamp, 
                                    status : PersonStatus.ACTIVE
                                }); 
        peopleByName[_name].push(id_);
        peopleByStatus[PersonStatus.ACTIVE].push(id_);
        personIdByAddress[_user] = id_;
        for(uint256 x = 0; x < _tags.length; x++) {
            peopleByTag[_tags[x]].push(id_); 
        }
        return personById[id_];
    }

    function removePerson(address _user) external returns (Person memory _removed){
        _removed = personById[personIdByAddress[_user]];
        personById[personIdByAddress[_user]].status = PersonStatus.REMOVED; 
        delete personIdByAddress[_user];
        return _removed; 
    }
}