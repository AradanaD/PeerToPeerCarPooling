const Carpooling = artifacts.require("Carpooling");

contract("Carpooling", (accounts) => {
  let carpooling;

  beforeEach(async () => {
    carpooling = await Carpooling.new();
  });

  it("should add a new ride", async () => {
    const departureTime = 1642892400; // Jan 22, 2022 6:00:00 PM GMT
    const availableSeats = 3;
    const pricePerSeat = web3.utils.toWei("0.1", "ether");

    await carpooling.addRide(departureTime, availableSeats, pricePerSeat, {
      from: accounts[0],
    });

    const ride = await carpooling.rides(1);

    assert.equal(ride.driver, accounts[0]);
    assert.equal(ride.departureTime, departureTime);
    assert.equal(ride.availableSeats, availableSeats);
    assert.equal(ride.pricePerSeat, pricePerSeat);
  });

  it("should find available rides", async () => {
    const departureTime1 = 1642892400; // Jan 22, 2022 6:00:00 PM GMT
    const availableSeats1 = 3;
    const pricePerSeat1 = web3.utils.toWei("0.1", "ether");

    const departureTime2 = 1642939200; // Jan 23, 2022 6:00:00 AM GMT
    const availableSeats2 = 1;
    const pricePerSeat2 = web3.utils.toWei("0.2", "ether");

    await carpooling.addRide(departureTime1, availableSeats1, pricePerSeat1, {
      from: accounts[0],
    });

    await carpooling.addRide(departureTime2, availableSeats2, pricePerSeat2, {
      from: accounts[1],
    });

    const results = await carpooling.findAvailableRides(departureTime1, pricePerSeat1);

    assert.equal(results.length, 1);
    assert.equal(results[0], 1);
  });

  it('should return empty array when no available rides are found', async function () {
    await carpooling.addRide(1648550400, 2, 100);
    await carpooling.addRide(1648550400, 1, 200);
    const results = await carpooling.findAvailableRides(1648550401, 50);
    assert.deepEqual(results, []);
  }); 

});







