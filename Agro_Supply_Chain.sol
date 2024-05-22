// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

contract foodchain{

    struct Product {
        uint256 productId;
        string productName;
        uint256 productWeight;
        uint256 productPrice;
        uint16[] productQuality;  
        string[]  subProduct; 
        address[] owners;
        uint256[] timeStamp;
     }

    error ASChain__InputRoleError();

    mapping(string => mapping(address => bool)) public roles;
    string[] public listOfRole = ["Producer", "Exporter", "Importer", "Manufacturer", "GroundTransport", "Shipping", "Warehouses", "InspectionAgency", "InsuranceCompany", "StandardsOrganization", "PortAuthority", "CustomeAuthority", "Consumer"];
    
    mapping(uint256 => Product) public listOfProduct;

    event ProductRegister(address indexed user, uint256 Id);
    event CropHarvested(address indexed user, uint256 Id);
    event ProductManufactured(address indexed user, uint256 Id);
    event ProductTransported(address indexed user, uint256 Id);
    event ProductExported(address indexed user, uint256 Id);
    event ProductImported(address indexed user, uint256 Id);
    event ProductShipped(address indexed user, uint256 Id);
    event ProductStored(address indexed user, uint256 Id);
    event ProductInspected(address indexed user, uint256 Id);
    event ProductInsured(address indexed user, uint256 Id);
    event ProductStandardise(address indexed user, uint256 Id);
    event ProductPortAuthorised(address indexed user, uint256 Id);
    event ProductCustomeAuthorised(address indexed user, uint256 Id);


    function register(string memory Role) public {
        bool validRole = false;
        for (uint256 i = 0; i < listOfRole.length; i++) {
            if (keccak256(abi.encodePacked(Role)) == keccak256(abi.encodePacked(listOfRole[i]))) {
            validRole = true;
            roles[Role][msg.sender] = true;
            break;
            }
        }
        if (!validRole) {
            revert ASChain__InputRoleError();
        }
    }

    function registerProduct(uint256 _productId, string memory _productName, uint256 _productWeight, uint256 _productPrice, string[] memory _subProduct) public {
        require(listOfProduct[_productId].productId == 0, "Product ID already exists");
        Product storage newProduct = listOfProduct[_productId];
        newProduct.productId = _productId;
        newProduct.productName = _productName;
        newProduct.productWeight = _productWeight;
        newProduct.productPrice = _productPrice;
        newProduct.subProduct = _subProduct;
        newProduct.owners.push(msg.sender);
        newProduct.timeStamp.push(block.timestamp);
        emit ProductRegister(msg.sender, _productId);
    }

    function GetProductInfo(uint256 _productId) public view returns(string memory , uint256 , uint256 , string[] memory , uint16[] memory , uint256[] memory ){
        Product memory product = listOfProduct[_productId];
        return (
            product.productName,
            product.productWeight,
            product.productPrice, 
            product.subProduct, 
            product.productQuality, 
            product.timeStamp
        );
    }

    function Harvest(uint256 _productId) public {
        require(roles["Producer"][msg.sender], "Function user must be Producer");
        emit CropHarvested(msg.sender, _productId);
    }

    function Manufactured(uint256 _productId) public {
        require(roles["Manufacturer"][msg.sender], "Function user must be Manufacture");
        emit ProductManufactured(msg.sender, _productId);
    }

    function Transport(uint256 _productId) public {
        require(roles["GroundTransport"][msg.sender], "Function user must be Transporter");
        emit ProductTransported(msg.sender, _productId);
    }

    function Exporter(uint256 _productId) public {
        require(roles["Exporter"][msg.sender], "Function user must be Exporter");
        emit ProductExported(msg.sender, _productId);
    }

    function Imported(uint256 _productId) public {
        require(roles["Importer"][msg.sender], "Function user must be Importer");
        emit ProductImported(msg.sender, _productId);
    }

    function Shipped(uint256 _productId) public {
        require(roles["Shipping"][msg.sender], "Function user must be Shipping Agency");
        emit ProductShipped(msg.sender, _productId);
    }

    function Warehouses(uint256 _productId) public {
        require(roles["Warehouses"][msg.sender], "Function user must be Warehouse Corporation");
        emit ProductStored(msg.sender, _productId);
    }

    function InspectionAgency(uint256 _productId) public {
        require(roles["InspectionAgency"][msg.sender], "Function user must be Inspection Agency");
        emit ProductInspected(msg.sender, _productId);
    }

    function InsuranceCompany(uint256 _productId) public {
        require(roles["InsuranceCompany"][msg.sender], "Function user must be Insurance Company");
        emit ProductInsured(msg.sender, _productId);
    }

    function StandardsOrganization(uint256 _productId) public {
        require(roles["StandardsOrganization"][msg.sender], "Function user must be Standard Organization");
        emit ProductStandardise(msg.sender, _productId);
    }

    function PortAuthority(uint256 _productId) public {
        require(roles["PortAuthority"][msg.sender], "Function user must be Port Authority");
        emit ProductPortAuthorised(msg.sender, _productId);
    }

    function CustomsAuthority(uint256 _productId) public {
        require(roles["CustomeAuthority"][msg.sender], "Function user must be Custome Authority");
        emit ProductCustomeAuthorised(msg.sender, _productId);
    }

}