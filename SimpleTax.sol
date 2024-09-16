// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaxiCashApp {
    // Define the owner of the contract (could be the platform)
    address public owner;
    
    // Define a structure for a Ride
    struct Ride {
        address rider;
        address driver;
        uint fare;
        bool isCompleted;
    }

    // Mapping from ride IDs to Ride details
    mapping(uint => Ride) public rides;
    uint public rideCounter = 0;

    // Events
    event RideRequested(address indexed rider, address indexed driver, uint rideId, uint fare);
    event RideCompleted(uint rideId, uint fare);
    event PaymentTransferred(address indexed driver, uint amount);

    // Modifier for owner-only functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this.");
        _;
    }

    // Constructor sets the owner
    constructor() {
        owner = msg.sender;
    }

    // Function for riders to request a ride (rider deposits funds for the fare)
    function requestRide(address _driver) public payable returns (uint) {
        require(msg.value > 0, "Fare must be greater than 0.");

        rideCounter++;
        rides[rideCounter] = Ride({
            rider: msg.sender,
            driver: _driver,
            fare: msg.value,
            isCompleted: false
        });

        emit RideRequested(msg.sender, _driver, rideCounter, msg.value);
        return rideCounter;
    }

    // Function for rider to mark ride as completed and transfer payment to the driver
    function completeRide(uint _rideId) public {
        Ride storage ride = rides[_rideId];

        // Check that the caller is the rider
        require(ride.rider == msg.sender, "Only the rider can complete the ride.");
        // Ensure that the ride is not already completed
        require(!ride.isCompleted, "Ride is already completed.");
        
        // Mark the ride as completed
        ride.isCompleted = true;

        // Transfer the fare to the driver
        (bool success, ) = payable(ride.driver).call{value: ride.fare}("");
        require(success, "Transfer to driver failed.");

        emit RideCompleted(_rideId, ride.fare);
        emit PaymentTransferred(ride.driver, ride.fare);
    }

    // Function to withdraw contract balance (owner-only)
    function withdraw(uint _amount) public onlyOwner {
        require(_amount <= address(this).balance, "Insufficient balance in contract.");
        
        (bool success, ) = payable(owner).call{value: _amount}("");
        require(success, "Withdrawal failed.");
    }

    // Fallback function to accept Ether sent directly to the contract
    receive() external payable {}

    // Function to check the contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
