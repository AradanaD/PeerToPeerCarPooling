// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Carpooling {
struct Ride {
address driver;
uint256 departureTime;
uint256 availableSeats;
uint256 pricePerSeat;
mapping (address => bool) passengers;
}

mapping (uint256 => Ride) public rides;
uint256 public rideCount;

function addRide(uint256 _departureTime, uint256 _availableSeats, uint256 _pricePerSeat) public {
    rideCount++;
    Ride storage newRide = rides[rideCount];
    newRide.driver = msg.sender;
    newRide.departureTime = _departureTime;
    newRide.availableSeats = _availableSeats;
    newRide.pricePerSeat = _pricePerSeat;
}

function findAvailableRides(uint256 _departureTime, uint256 _maxPricePerSeat) public view returns (uint256[] memory) {
    uint256[] memory results = new uint256[](rideCount);
    uint256 count = 0;

    for (uint256 i = 1; i <= rideCount; i++) {
        Ride storage ride = rides[i];
        if (ride.departureTime == _departureTime && ride.pricePerSeat <= _maxPricePerSeat && ride.availableSeats > 0) {
            results[count] = i;
            count++;
        }
    }

    uint256[] memory finalResults = new uint256[](count);
    for (uint256 i = 0; i < count; i++) {
        finalResults[i] = results[i];
    }

    return finalResults;
}

function bookRide(uint256 _rideId) public payable {
    Ride storage ride = rides[_rideId];
    require(ride.availableSeats > 0, "No available seats");
    require(!ride.passengers[msg.sender], "Already booked");
    require(msg.value == ride.pricePerSeat, "Incorrect payment amount");

    ride.passengers[msg.sender] = true;
    ride.availableSeats--;

    payable(ride.driver).transfer(msg.value);
}

function cancelBooking(uint256 _rideId) public {
    Ride storage ride = rides[_rideId];
    require(ride.passengers[msg.sender], "Not booked");

    ride.passengers[msg.sender] = false;
    ride.availableSeats++;
    payable(msg.sender).transfer(ride.pricePerSeat);
}

}