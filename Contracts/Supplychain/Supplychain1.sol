pragma solidity ^0.8.0 ;
import "../Ownership/Ownable.sol" ;
import "../Access/Manufacturer.sol";
import "../Access/Distributor.sol";
import "../Access/Wholesaler.sol";
import "../Access/Retailer.sol";
import "../Access/Consumer.sol";

contract  Supplychain1 is 
    Manufacturer , 
    Distributor,
    Wholesaler, 
    Retailer, 
    Consumer {
        address owner ;
        uint256 productCode ;
        uint256 stockUnit;
        mapping ( uint256 =>Item ) items ;
        mapping(uint256 => txBlocks) itemsHistory;
        enum state{
        ProducedByManufacturer, // 0
        ForSaleByManufacturer, // 1
        PurchasedByDistributor, // 2
        ShippedByManufacturer, // 3
        ReceivedByDistributor, // 4
        ProcessedByDistributor,
        ForSaleByDistributor, // 5
        PurchasedByWholesaler, // 6
        ShippedByDistributor, // 7
        ReceivedByWholesaler, // 8
        ProcessedByWholesaler,
        ForSaleByWholesaler, // 9
        PurchasedByRetailer, // 10
        ReceivedByRetailer, // 11
        ProcessedByRetailer ,
        ForSaleByRetailer, // 12
        PurchasedByConsumer // 13
                
        

    }
        state constant defaultState = state.ProducedByManufacturer;
constructor()
         public 
         payable {        
        owner = _msgSender();        
        stockUnit = 1;        
        productCode = 1;    
}

        struct Item {
            uint256 stockUnit;
            uint256 productCode;
            address ownerID;
            address manufacturerID;
            uint256 productID;
            string productInfo;
            state itemState ;
            uint256 productPrice;
            uint256 productSliced;
            
            address wholesalerID;
            address distributorID;
            address retailerID;
            address consumerID;
            uint256 itemPrice ;
            uint256 ProductQuantity;
           





        }
        struct txBlocks { 
        uint256 MTD; // block of ManufacturerToDistributor 
        uint256 DTW; // block of DistributorToWholesaler
        uint256 WTR ;// block of WholesalerTo Retailer 
        uint256 RTC; // block of RetailerToConsumer
       
      }

      event  ProducedByManufacturer(uint256 productCode ); // 0
      event  ForSaleByManufacturer (uint256 productCode );// 1
      event  PurchasedByDistributor (uint256 productCode ); // 2
      event  ShippedByManufacturer (uint256 productCode ); // 3
      event  ReceivedByDistributor (uint256 productCode ); // 4
      event  ProcessedByDistributor(uint256 productCode);//5
      event  ForSaleByDistributor(uint256 productCode ); // 6
      event  PurchasedByWholesaler (uint256 productCode ); // 7
      event  ShippedByDistributor (uint256 productCode ); // 8
      event  ReceivedByWholesaler (uint256 productCode ); // 9
      event ProcessedByWholesaler (uint256 productCode ); //10
      event  ForSaleByWholesaler (uint256 productCode ); // 11
      event  PurchasedByRetailer (uint256 productCode ); // 12
      event ShippedByWholesaler(uint256 productCode); //13
      event  ReceivedByRetailer (uint256 productCode ); // 14
      event ProcessedByRetailer(uint256 productCode); //15
      event  ForSaleByRetailer (uint256 productCode );// 16
      event  PurchasedByConsumer  (uint256 productCode );// 17

    // Define a modifer that checks to see if _msgSender() == owner of the contract
    modifier only_Owner() {
        require(_msgSender() == owner);
        _;
    }

    // Define a modifer that verifies the Caller
    modifier verifyCaller(address _address) {
        require(_msgSender() == _address);
        _;
    }

    // Define a modifier that checks if the paid amount is sufficient to cover the price
    modifier paidEnough(uint256 _price) {
        require(msg.value >= _price);
        _;
    }

    // Define a modifier that checks the price and refunds the remaining balance
    modifier checkValue(uint256 _productCode, address payable addressToFund) {
        uint256 _price = items[_productCode].itemPrice;
        uint256 amountToReturn = msg.value - _price;
        addressToFund.transfer(amountToReturn);
        _;
    }

      modifier _ProducedByManufacturer (uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ProducedByManufacturer) ;
          _;
        } //0
         
        
        modifier _ForSaleByManufacturer(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ForSaleByManufacturer) ;
          _;
        }  //1 
        modifier _PurchasedByDistributor(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.PurchasedByDistributor) ;
          _;
        } // 2
        modifier _ShippedByManufacturer(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ShippedByDistributor) ;
          _;
        }  // 3
        modifier _ReceivedByDistributor(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ReceivedByDistributor) ;
          _;
        }  // 4

        modifier _ProcessedByDistributor(uint256 _ProductCode){
          require (items[ _ProductCode].itemState == state.ProcessedByDistributor);
          _;
        }// 5
        modifier _ForSaleByDistributor(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ForSaleByDistributor) ;
          _;
        }  // 6
        modifier _PurchasedByWholesaler (uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.PurchasedByWholesaler) ;
          _;
        }  // 7
        modifier _ShippedByDistributor(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ShippedByDistributor) ;
          _;
        }  // 8
        modifier _ReceivedByWholesaler(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ReceivedByWholesaler) ;
          _;
        }  // 9
        modifier _ProcessedByWholesaler(uint256 _ProductCode){
          require (items[ _ProductCode].itemState == state.ProcessedByWholesaler);
          _;
        } //10
         modifier _ForSaleByWholesaler(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ForSaleByWholesaler) ;
          _;
        }  // 11

        modifier _PurchasedByRetailer(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.PurchasedByRetailer) ;
          _;
        }  // 12

        // modifier _ShippedByWholesaler(uint256 _ProduceCode){
        //   require(items[_ProduceCode].itemState == state.ShippedByWholesaler );
        //   _;
        // }
        modifier _ReceivedByRetailer(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ReceivedByRetailer) ;
          _;
        }  // 13
         modifier _ProcessedByRetailer(uint256 _ProductCode){
          require (items[ _ProductCode].itemState == state.ProcessedByRetailer);
          _;
        } // 14
        modifier _ForSaleByRetailer(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.ForSaleByRetailer) ;
          _;
        }  // 15
        modifier _PurchasedByConsumer(uint256 _ProductCode){
          require(items[_ProductCode].itemState == state.PurchasedByConsumer) ;
          _;
        }  // 16

        function kill() public {
        if (_msgSender() == owner) {
            address payable ownerAddressPayable = _make_payable(owner);
            selfdestruct(ownerAddressPayable);
        }
    }

    // allows you to convert an address into a payable address
    function _make_payable(address x) internal pure returns (address payable) {
        return payable(address(uint160(x)));
    }
        

        
        // 0th sate of supply chain produced by manufacturer 

        function ProduceItemByManufacturer(
          uint256 _productCode,
          string memory  _productInfo,
          uint256 _price 
        )
        public 
        onlyManufacturer
        {
        //  address manufacturerID;
          address distributorID;
          address wholesalerID;
          address retailerID;
          address consumerID;
          
          Item memory newProduce;
          newProduce.manufacturerID = _msgSender();
          newProduce.stockUnit = stockUnit;
          newProduce.productCode = _productCode;
          newProduce.ownerID = _msgSender();
          newProduce.productInfo = _productInfo;
          newProduce.productPrice = _price;
          newProduce.productID = _productCode+stockUnit;
          newProduce.itemState = defaultState;


          newProduce.wholesalerID = wholesalerID;
          newProduce.distributorID = distributorID;
          newProduce.retailerID = retailerID;
          newProduce.consumerID = consumerID;
          newProduce.productSliced = 0;
          
          items[_productCode] = newProduce ;
          uint256  placeholder;
          txBlocks memory txBlock;
          
          txBlock.MTD = placeholder; // assign placeholder values
          txBlock.DTW = placeholder;
          txBlock.WTR = placeholder;
          txBlock.RTC = placeholder;
          itemsHistory[productCode] = txBlock;

          stockUnit++;
          emit ProducedByManufacturer(productCode);
        }

         // 1st stage  sell by manufacturer 

        function sellItemByFarmer(uint256 _productCode, uint256 _price)
        public
        onlyManufacturer 
         _ProducedByManufacturer (_productCode)// check items state has been produced
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is owner
    {
        items[_productCode].itemState = state.ForSaleByManufacturer;
        items[_productCode].productPrice = _price;
        emit ForSaleByManufacturer(_productCode);
    }


    //  2nd stage Purchase by Distributor 
    function purchaseItemByDistributor(uint256 _productCode)
        public
        payable
        onlyDistributor // check _msgSender() belongs to distributorRole
        _ForSaleByManufacturer(_productCode)// check items state is for ForSaleByFarmer
        paidEnough(items[_productCode].productPrice) // check if distributor sent enough Ether for item
        checkValue(_productCode, payable(_msgSender())) // check if overpayed return remaing funds back to _msgSender()
    {
        address payable ownerAddressPayable = _make_payable(
            items[_productCode].manufacturerID
        ); 
        ownerAddressPayable.transfer(items[_productCode].productPrice); // transfer funds from distributor to farmer
        items[_productCode].ownerID = _msgSender(); // update owner
        items[_productCode].distributorID = _msgSender(); // update distributor
        items[_productCode].itemState = state.PurchasedByDistributor; // update state
        itemsHistory[_productCode].MTD = block.number; // add block number
        emit PurchasedByDistributor(_productCode);
    }



   /* 3rd step in supplychain
  Allows Manufacturer  to ship product purchased by distributor
  */
    function shippedItemByManufacturer(uint256 _productCode)
        public
        payable
        onlyManufacturer // check _msgSender() belongs to FarmerRole
       _PurchasedByDistributor(_productCode)
        verifyCaller(items[_productCode].manufacturerID) // check _msgSender() is origin Manufatcurer 
    {
        items[_productCode].itemState = state.ShippedByManufacturer; // update state
        emit ShippedByManufacturer(productCode);

        }

/*
         4th step in supplychain
  Allows distributor to receive product
  */
    function receivedItemByDistributor(uint256 _productCode)
        public
        onlyDistributor // check _msgSender() belongs to DistributorRole
        _ShippedByManufacturer(_productCode)
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is owner
    {
        items[_productCode].itemState =state.ReceivedByDistributor; // update state
        emit ReceivedByDistributor(_productCode);
    }

    // 5th stage is processing by distributer into slices 

    function processedItemByDistributor(uint256 _productCode , uint256 slices)
    public
     onlyDistributor 
     _ReceivedByDistributor(_productCode)
     verifyCaller (items[_productCode].ownerID){
       items[_productCode].itemState = state.ProcessedByDistributor;
       items[_productCode].productSliced = slices;
       emit ProcessedByDistributor(_productCode);


     }

     // 6th stage sell item by distributor 

     function sellItemByDistributor(uint256 _productCode, uint _price)
     public 
     onlyDistributor
     _ProcessedByDistributor(_productCode)
     verifyCaller(items[_productCode].ownerID){
       items[_productCode].itemState = state.ForSaleByWholesaler;
       items[_productCode].productPrice = _price;
       emit ForSaleByDistributor(_productCode);
     }

     // 7th stage purchase item by wholesaler 


      function purchaseItemByWholesaler(uint256 _productCode)
        public
        payable
        onlyWholesaler // check _msgSender() belongs to distributorRole
        _ForSaleByDistributor(_productCode)// check items state is for ForSaleByFarmer
        paidEnough(items[_productCode].productPrice) // check if distributor sent enough Ether for item
        checkValue(_productCode, payable(_msgSender())) // check if overpayed return remaing funds back to _msgSender()
    {
        address payable ownerAddressPayable = _make_payable(
            items[_productCode].distributorID
        ); 
        ownerAddressPayable.transfer(items[_productCode].productPrice); // transfer funds from distributor to farmer
        items[_productCode].ownerID = _msgSender(); // update owner
        items[_productCode].wholesalerID = _msgSender(); // update distributor
        items[_productCode].itemState = state.PurchasedByWholesaler; // update state
        itemsHistory[_productCode].DTW = block.number; // add block number
        emit PurchasedByWholesaler(_productCode);
    }



  //  8th shipping item to wholesaler by distribbutor 

    function shippedItemByDistributor(uint256 _productCode)
        public
        payable
        onlyDistributor // check _msgSender() belongs to FarmerRole
       _PurchasedByWholesaler(_productCode)
        verifyCaller(items[_productCode].distributorID) // check _msgSender()  
    {
        items[_productCode].itemState = state.ShippedByDistributor; // update state
        emit ShippedByDistributor(productCode);

        }

// 9th stage  item recieved by wholesaler

    function receivedItemByWholesalerr(uint256 _productCode)
        public
        onlyDistributor // check _msgSender() belongs to DistributorRole
        _ShippedByDistributor(_productCode)
        verifyCaller(items[_productCode].ownerID) // check _msgSender() is owner
    {
        items[_productCode].itemState =state.ReceivedByWholesaler; // update state
        emit ReceivedByWholesaler(_productCode);
    }

    // 10th stage is processing by wholesaler  into slices 

    function processedItemByWholesaler(uint256 _productCode , uint256 slices)
    public
     onlyWholesaler
     _ReceivedByWholesaler(_productCode)
     verifyCaller (items[_productCode].ownerID){
       items[_productCode].itemState = state.ProcessedByWholesaler;
       items[_productCode].productSliced = slices;
       emit ProcessedByWholesaler(_productCode);


     }

     // 11th stage  item on sale by wholesaler for retalier 
     function sellItemByWholesaler(uint256 _productCode, uint _price)
     public 
     onlyWholesaler
     _ProcessedByWholesaler(_productCode)
     verifyCaller(items[_productCode].ownerID){
       items[_productCode].itemState = state.ForSaleByWholesaler;
       items[_productCode].productPrice = _price;
       emit ForSaleByWholesaler(_productCode);
     }

     // 12th stage item purchased by retailer 
      function purchaseItemByRetailer(uint256 _productCode)
        public
        payable
        onlyWholesaler 
        _ForSaleByWholesaler(_productCode)// check items state is for ForSaleByFarmer
        paidEnough(items[_productCode].productPrice) 
        checkValue(_productCode, payable(_msgSender())){

        address payable ownerAddressPayable = _make_payable(
            items[_productCode].wholesalerID
        ); 
        ownerAddressPayable.transfer(items[_productCode].productPrice); 
        items[_productCode].ownerID = _msgSender(); // update owner
        items[_productCode].retailerID = _msgSender();
        items[_productCode].itemState = state.PurchasedByRetailer; // update state
        itemsHistory[_productCode].WTR = block.number; // add block number
        emit PurchasedByRetailer(_productCode);
    }

    // 13 stage  item shipped by wholesaler 
    
    // function shippedItemByWholesaler(uint256 _productCode)
    //     public
    //     payable
    //     onlyWholesaler // check _msgSender() belongs to FarmerRole
    //    _PurchasedByRetailer(_productCode)
    //     verifyCaller(items[_productCode].wholesalerID) // check _msgSender()  
    // {
    //     items[_productCode].itemState = state.ShippedByWholesaler; // update state
    //     emit ShippedByWholesaler(_productCode);

    //     }






     



        

    }