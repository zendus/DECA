//SPDX-License-Identifier: UNLICENSED 
pragma solidity >=0.5.0 < 0.9.0;

/// @title A decentralized e-commerce smart contract
/// @notice This contract depicts the basic functionalities of an e-commerce platform
contract DECA {

    /// @notice State variable storing address of contract deployer aka owner
    address payable public owner;



    /// @notice Struct with all the features for a single product
    struct Product {
        uint id;
        uint price;
        string title;
        string image_cid;
        string description;
        address payable seller;
    }

    /// @notice A mapping of buyer address to list of products ordered
    mapping (address => Product[]) cart;

    /// @notice An array of all available products
    /// @dev It is of type Product struct
    Product[] public products;

    /// @notice A number used to keep track of product IDs
    uint256 private idCount = 1;

    /// @notice Emitted when a product is registered by a seller
    event LogProductUpload(uint256 productID, uint256 timeUploaded);

    /// @notice Emitted when a product is added to cart by a potential buyer
    event LogUserCartUpdated(address indexed user, uint256 productID, uint256 timeAdded);

    /// @notice Assigns owner role to the contract deployer address
    constructor() {
        owner = payable(msg.sender);
    }

    /// @param _price cost of the product in ethers
    /// @param _title name of the product
    /// @param _image_cid image content identifier
    /// @param _description small description of the product
    /// @dev The ether price is converted to wei before storage
    function uploadProduct(uint _price, string memory _title,
    string memory _image_cid, string memory _description) external {
        products.push(Product({id: idCount, price: _price * 10 ** 18, title: _title, 
        image_cid: _image_cid, description: _description, seller: payable(msg.sender)}));
        emit LogProductUpload(idCount, block.timestamp);
        idCount++;
    }

    /// @param productID unique id of product to be added
    /// @dev since index starts from 0, productID-1 was used to index the products array
    function addToCart(uint productID) external {
        cart[msg.sender].push(products[productID-1]);
        emit LogUserCartUpdated(msg.sender, productID, block.timestamp);
    }

    // function checkIfProductExists(uint productID) private returns(bool) {}

    /// @notice returns tuple containing user products
    function viewCart() external view returns(Product[] memory) {
        return cart[msg.sender];
    }

}