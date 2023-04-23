// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./Roles.sol";
import "../Utils/Context.sol";

contract Manufacturer is Context{


   using Roles for Roles.Role;



   event ManufacturerAdded(address indexed account );
   event ManufacturerRemoved(address indexed account );

   Roles.Role private manufacturers;

   // 

   constructor() {
       _addManufacturer(_msgSender());

   }
    // defining modifier to check the callling address has an appropriate role 
   modifier onlyManufacturer {
       require(isManufacturer(_msgSender()));
       _;
   }
   // function to check if address is of correct role or not 
    function isManufacturer(address account )
    public 
    view 
    returns (bool){
        return manufacturers.has(account);
    }
    
    function addManufacturer (address account) public onlyManufacturer{
        _addManufacturer(account);
    }

    function  renouceManufaturer() public{
        
        _removeManufacturer(_msgSender());
    }

    function _addManufacturer  (address account ) internal{
        manufacturers.add(account);
        emit ManufacturerAdded(account);
    }
    
    function _removeManufacturer(address account ) internal {
        manufacturers.remove(account);
        emit ManufacturerRemoved(account );
    }


}