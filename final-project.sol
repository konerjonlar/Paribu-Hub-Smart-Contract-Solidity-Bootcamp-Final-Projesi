// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentalContract {
    struct User {
        string name;
        address userAddress;
        bool isTenant;
        bool isLandlord;
    }

    struct Property {
        address owner;
        bool isHouse;
        uint256 rentStartDate;
        uint256 rentEndDate;
        bool isRented;
        address tenant;
    }

    // Event for reporting issues
    event IssueReported(address indexed _user, string _issueDetails);

    // Modifier for allowing only tenants to perform certain actions
    modifier onlyTenant() {
        require(users[msg.sender].isTenant, "Only tenants can perform this action.");
        _;
    }

    // Modifier for allowing only landlords to perform certain actions
    modifier onlyLandlord() {
        require(users[msg.sender].isLandlord, "Only landlords can perform this action.");
        _;
    }

    // Mapping to store user data
    mapping(address => User) public users;
    
    // Mapping to store property data
    mapping(address => Property) public properties;

    // Constructor to initialize an admin user
    constructor() {
        users[msg.sender] = User({
            name: "Admin",
            userAddress: msg.sender,
            isTenant: false,
            isLandlord: false
        });
    }

    // Function to create a new user with specified role
    function createUser(string memory _name, bool _isTenant, bool _isLandlord) public {
        require(!_isTenant || !_isLandlord, "A user cannot be both tenant and landlord.");
        users[msg.sender] = User({
            name: _name,
            userAddress: msg.sender,
            isTenant: _isTenant,
            isLandlord: _isLandlord
        });
    }

    // Function to define property details by landlords
    function defineProperty(bool _isHouse, uint256 _rentStartDate, uint256 _rentEndDate) public onlyLandlord {
        require(_rentStartDate < _rentEndDate, "Rent start date must be before the rent end date.");
        properties[msg.sender] = Property({
            owner: msg.sender,
            isHouse: _isHouse,
            rentStartDate: _rentStartDate,
            rentEndDate: _rentEndDate,
            isRented: false,
            tenant: address(0)
        });
    }

    // Function for tenants to rent a property
    function rentProperty(address _tenant) public onlyTenant {
        Property storage property = properties[msg.sender];
        require(!property.isRented, "Property is already rented.");
        require(block.timestamp < property.rentEndDate, "Rent end date has passed.");
        property.isRented = true;
        property.tenant = _tenant;
    }

    // Function for landlords to end a rental
    function endRental() public {
        Property storage property = properties[msg.sender];
        require(property.isRented, "Property is not rented.");
        require(block.timestamp >= property.rentEndDate, "Rental cannot be ended before the rental period ends.");
        property.isRented = false;
        property.tenant = address(0);
    }

    // Function for users to report issues
    function reportIssue(string memory _issueDetails) public {
        require(bytes(_issueDetails).length > 0, "Issue details cannot be empty.");
        emit IssueReported(msg.sender, _issueDetails);
    }
}
