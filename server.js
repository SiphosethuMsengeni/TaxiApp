// Import required modules
const express = require('express');
const bodyParser = require('body-parser');

// Initialize the app
const app = express();

// Use middleware to parse JSON requests
app.use(bodyParser.json());

// Mock data to store bookings (you might replace this with a database)
let bookings = [];

// Booking Endpoint
app.post('/book', (req, res) => {
    const { from, destination, fare } = req.body;

    // Validate the input
    if (!from || !destination || !fare) {
        return res.status(400).json({ success: false, message: 'Invalid booking data' });
    }

    // Add booking to mock database
    const booking = { from, destination, fare };
    bookings.push(booking);

    // Simulate booking success
    console.log(`Booking created: ${JSON.stringify(booking)}`);
    res.json({ success: true, message: 'Booking successful', booking });
});

// Payment Endpoint
app.post('/book', (req, res) => {
    console.log(req.body); // Check if the payload is received
    const { from, destination, fare } = req.body;

    if (!from || !destination || !fare) {
        return res.status(400).json({ success: false, message: 'Invalid booking data' });
    }

    const booking = { from, destination, fare };
    bookings.push(booking);

    res.json({ success: true, message: 'Booking successful', booking });
});


// Set up the server to listen on port 3000
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
