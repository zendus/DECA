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
    mapping (address => uint[]) cart;

    /// @notice An array of all available products
    /// @dev It is of type Product struct
    Product[] public products;

    /// @notice A number used to keep track of product IDs
    uint256 private idCount = 1;

    /// @notice Emitted when a product is registered by a seller
    event LogProductUpload(uint256 productID, uint256 timeUploaded);

    /// @notice Emitted when a product is added to cart by a potential buyer
    event LogUserCartUpdated(address indexed user, uint256 productID, uint256 timeAdded);

    /// @notice Emitted when product is purchased
    event LogProductPurchase(address indexed user, uint[] items, uint purchaseTime);

    /// @notice Assigns owner role to the contract deployer address
    constructor() {
        owner = payable(msg.sender);
    }

    /// @notice Checks if product ID exists in products array
    modifier productExists(uint _productID) {
        require(products[_productID-1].id  != 0, "Product does not exist");
        _;
    }

    /// @notice Checks if msg.sender is owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    /// @param _price cost of the product in ethers
    /// @param _title name of the product
    /// @param _image_cid image content identifier
    /// @param _description small description of the product
    /// @dev The ether price is converted to wei before storage
    function uploadProduct(uint _price, string memory _title,
    string memory _image_cid, string memory _description) external {
        require(_price != 0, "Product price must be greater than zero");
        products.push(Product({id: idCount, price: _price * 10 ** 18, title: _title, 
        image_cid: _image_cid, description: _description, seller: payable(msg.sender)}));
        emit LogProductUpload(idCount, block.timestamp);
        idCount++;
    }

    /// @param productID unique id of product to be added
    /// @dev since index starts from 0, productID-1 was used to index the products array
    function addToCart(uint productID) external productExists(productID) {
        cart[msg.sender].push(productID);
        emit LogUserCartUpdated(msg.sender, productID, block.timestamp);
    }

    /// @return A uint array of product IDs
    function viewCart() external view returns(uint[] memory) {
        return cart[msg.sender];
    }

    /// @notice Adds the ether sent by the buyer to the contract balance
    function purchase() external payable {
        require(msg.value == totalAmountToPay(msg.sender), "Amount not enough");
        emit LogProductPurchase(msg.sender, cart[msg.sender], block.timestamp);
    }

    /// @notice Calculates the total cost of products in a cart
    /// @param addr Address of the buyer
    /// @return The total cost
    function totalAmountToPay(address addr) private view returns(uint) {
        uint totalAmount;
        for (uint i = 0; i < cart[addr].length; ++i) {
            totalAmount += products[i].price;
        }
        return totalAmount;
    }

    /// @return The contract ether balance
    function contractBalance() external view onlyOwner returns(uint) {
        return address(this).balance;
    }

}