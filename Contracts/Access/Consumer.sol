// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./Roles.sol";
import "../Utils/Context.sol";

contract Consumer is Context{


   using Roles for Roles.Role;



   event ConsumerAdded(address indexed account );
   event ConsumerRemoved(address indexed account );

   Roles.Role private consumers;

   // 

   constructor() {
       _addConsumer(_msgSender());

   }
    // defining modifier to check the callling address has an appropriate role 
   modifier onlyConsumer {
       require(isConsumer(_msgSender()));
       _;
   }
   // function to check if address is of correct role or not 
    function isConsumer(address account )
    public 
    view 
    returns (bool){
        return consumers.has(account);
    }
    
    function addConsumer (address account) public onlyConsumer{
        _addConsumer(account);
    }

    function  renouceConsumer() public{
        
        _removeConsumer(_msgSender());
    }

    function _addConsumer  (address account ) internal{
        consumers.add(account);
        emit ConsumerAdded(account);
    }
    
    function _removeConsumer(address account ) internal {
        consumers.remove(account);
        emit ConsumerRemoved(account );
    }


}