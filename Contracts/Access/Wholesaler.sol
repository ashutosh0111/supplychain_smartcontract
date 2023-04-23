// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./Roles.sol";
import "../Utils/Context.sol";

contract Wholesaler is Context{


   using Roles for Roles.Role;



   event WholesalerAdded(address indexed account );
   event WholesalerRemoved(address indexed account );

   Roles.Role private wholesalers;

   // 

   constructor() {
       _addWholesaler(_msgSender());

   }
    // defining modifier to check the callling address has an appropriate role 
   modifier onlyWholesaler {
       require(isWholesaler(_msgSender()));
       _;
   }
   // function to check if address is of correct role or not 
    function isWholesaler(address account )
    public 
    view 
    returns (bool){
        return wholesalers.has(account);
    }
    
    function addWholesaler (address account) public onlyWholesaler{
        _addWholesaler(account);
    }

    function  renouceWholesaler() public{
        
        _removeWholesaler(_msgSender());
    }

    function _addWholesaler  (address account ) internal{
        wholesalers.add(account);
        emit WholesalerAdded(account);
    }
    
    function _removeWholesaler(address account ) internal {
        wholesalers.remove(account);
        emit WholesalerRemoved(account );
    }


}