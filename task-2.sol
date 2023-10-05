// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Tenant {
    string name;
    address addressInfo;
}

struct RentalAsset {
    address owner;
    bool isHouse;
    uint256 rentStartDate;
    uint256 rentEndDate;
}

contract RentalContract {
    mapping(address => Tenant) public tenants;
    mapping(address => RentalAsset) public rentalAssets;

    function rentOut(address _tenant, bool _isHouse, uint256 _rentStartDate, uint256 _rentEndDate) public {
        require(msg.sender != _tenant, "Landlord cannot be the tenant at the same time.");
        require(_rentStartDate < _rentEndDate, "Rent start date must be before the rent end date.");

        tenants[_tenant] = Tenant({
            name: "Tenant Name",
            addressInfo: _tenant
        });

        rentalAssets[msg.sender] = RentalAsset({
            owner: msg.sender,
            isHouse: _isHouse,
            rentStartDate: _rentStartDate,
            rentEndDate: _rentEndDate
        });
    }

    function endRental(address _tenant) public {
        RentalAsset storage asset = rentalAssets[msg.sender];
        require(asset.owner == msg.sender, "Only the asset owner can end the rental.");
        require(block.timestamp >= asset.rentEndDate, "Rental cannot be ended before the rental period ends.");

        delete tenants[_tenant];
        delete rentalAssets[msg.sender];
    }

    event IssueReported(address indexed _tenant, string _issueDetails);

    function reportIssue(string memory _issueDetails) public {
        require(bytes(_issueDetails).length > 0, "Issue details cannot be empty.");
        emit IssueReported(msg.sender, _issueDetails);
    }
}
