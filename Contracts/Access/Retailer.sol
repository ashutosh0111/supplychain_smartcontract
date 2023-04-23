// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./Roles.sol";
import "../Utils/Context.sol";

contract Retailer is Context{


   using Roles for Roles.Role;



   event RetailerAdded(address indexed account );
   event RetailerRemoved(address indexed account );

   Roles.Role private retailers;

   // 

   constructor() {
       _addRetailer(_msgSender());

   }
    // defining modifier to check the callling address has an appropriate role 
   modifier onlyRetailer {
       require(isRetailer(_msgSender()));
       _;
   }
   // function to check if address is of correct role or not 
    function isRetailer(address account )
    public 
    view 
    returns (bool){
        return retailers.has(account);
    }
    
    function addRetailer (address account) public onlyRetailer{
        _addRetailer(account);
    }

    function  renouceRetailer() public{
        
        _removeRetailer(_msgSender());
    }

    function _addRetailer  (address account ) internal{
        retailers.add(account);
        emit RetailerAdded(account);
    }
    
    function _removeRetailer(address account ) internal {
        retailers.remove(account);
        emit RetailerRemoved(account );
    }


}