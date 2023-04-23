// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./Roles.sol";
import "../Utils/Context.sol";

contract Distributor is Context{


   using Roles for Roles.Role;



   event DistributorAdded(address indexed account );
   event DistributorRemoved(address indexed account );

   Roles.Role private distributors;

   // 

   constructor() {
       _addDistributor(_msgSender());

   }
    // defining modifier to check the callling address has an appropriate role 
   modifier onlyDistributor {
       require(isDistributor(_msgSender()));
       _;
   }
   // function to check if address is of correct role or not 
    function isDistributor(address account )
    public 
    view 
    returns (bool){
        return distributors.has(account);
    }
    
    function addDistributor (address account) public onlyDistributor{
        _addDistributor(account);
    }

    function  renouceDistributor() public{
        
        _removeDistributor(_msgSender());
    }

    function _addDistributor  (address account ) internal{
        distributors.add(account);
        emit DistributorAdded(account);
    }
    
    function _removeDistributor(address account ) internal {
        distributors.remove(account);
        emit DistributorRemoved(account );
    }


}