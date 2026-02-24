// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "./IERC20.sol";

contract PropertyManagement  {
    error NOT_OWNER();
    error NOT_FOR_SALE();
    error ALREADY_SOLD();
    error INSUFFICIENT_FUNDS();
    error ADDRESS_ZERO_CANT_PURCHASE_PROPERTY();


    Property[] public properties;
    uint256 property_id;
    IERC20 public snow;

    event PropertyAdded (string name, string location, uint256 _price);
    event PropertyRemoved (string name, string location, uint256 _price); 

    modifier onlyOwner(uint256 _property_id) {
         Property memory property = properties[_property_id -1];
         address Owner = property.propertyOwner;
        if (Owner != msg.sender) {
            revert NOT_OWNER();
        }
        _;
    }

    struct Property {
        string name;
        string location;
        uint256  id;
        uint256 price;
        uint256 timeSold;
        bool forSale;
        bool isSold;
        address propertyOwner;

    }

    constructor(address _snowAddress)  {
        snow = IERC20(_snowAddress);

    }

    function createProperty(string memory _name, string memory _location, uint256 _price) external  returns(string memory, string memory, uint256) {
         property_id = property_id +1;

        Property memory newProperty = Property({
            id: property_id, 
            name: _name,
            location: _location,
            price: _price,
            timeSold: 0,
            forSale: true,
            isSold: false,
            propertyOwner: msg.sender
        });
        emit PropertyAdded(_name, _location, _price);

        // return (_name, _location, _price);

        properties.push(newProperty);
    }

    function removeProperty (uint8 _property_id) external  onlyOwner(_property_id){
        Property memory property = properties[_property_id -1];
        string memory _name = property.name;
        string memory _location = property.location;
        if (property.isSold == true) {
            revert ALREADY_SOLD();
        }
        for (uint8 i; i < properties.length; i++) {
            if (properties[i].id ==  _property_id) {
                properties[i] = properties [properties.length -1];
                properties.pop();
            }
        }

        emit PropertyRemoved(_name, _location, property.price);
    }

    function purchaseProperty(uint8 _property_id) external {
        Property storage property = properties[_property_id -1];

        if (msg.sender == address(0)) {
            revert ADDRESS_ZERO_CANT_PURCHASE_PROPERTY();
        }

        if (property.forSale == false) {
            revert NOT_FOR_SALE();
        }

        if (property.isSold == true) {
            revert ALREADY_SOLD();
        }
        address seller = property.propertyOwner;
        uint256 _price = property.price;

        property.propertyOwner = msg.sender;
        property.isSold = true;
        property.forSale = false;

         bool success = snow.transferFrom(msg.sender, seller, _price);

         require(success, "transfer failed");
      
    }

    function getAllProperties() external view returns (Property[] memory) {
        return properties;
    }


}