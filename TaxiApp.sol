// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaxiAppPayment {
    address public owner;
    uint256 public totalPayments;

    // Minimum and maximum payment values in wei
    uint256 public constant MIN_PAYMENT = 0.001 ether;
    uint256 public constant MAX_PAYMENT = 10 ether;

    event PaymentReceived(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Pay for taxi service (payable function to receive Ether)
    function payForTaxi() external payable {
        // Ensure the payment is between the allowed range
        require(msg.value > 0, "Payment must be greater than 0.");
        require(msg.value >= MIN_PAYMENT, "Payment must be at least 0.001 ether.");
        require(msg.value <= MAX_PAYMENT, "Payment cannot exceed 10 ether.");

        // Increment total payments
        totalPayments += msg.value;

        emit PaymentReceived(msg.sender, msg.value);
    }

    // Withdraw the collected payments to the owner's address
    function withdrawFunds() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available to withdraw.");

        // Transfer balance to the owner's wallet
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed.");

        emit Withdrawn(owner, balance);
    }

    // Check contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
