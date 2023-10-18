// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Use SafeMath to prevent integer overflows/underflows
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MyToken {
    using SafeMath for uint256;

    // Token balances of each address
    mapping(address => uint256) public balances;

    // Event to notify off-chain applications of transfers
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Initialize the contract
    constructor() {
        balances[msg.sender] = 1000000; // Assign an initial balance to the contract owner
    }

    // Transfer tokens to a specified address
    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance"); // Check if the sender has enough tokens
        
        balances[msg.sender] = balances[msg.sender].sub(amount); // Deduct the tokens from the sender
        balances[to] = balances[to].add(amount); // Add the tokens to the recipient

        emit Transfer(msg.sender, to, amount); // Notify off-chain applications of the transfer
    }
}
