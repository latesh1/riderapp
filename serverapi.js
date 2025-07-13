const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json()); 
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log(" Connected to MongoDB"))
  .catch(err => console.error(" MongoDB connection error:", err));

const pickupSchema = new mongoose.Schema({
  lat: Number,
  lng: Number,
  time_slot: String,
  inventory: Number,
});

const warehouseSchema = new mongoose.Schema({
  lat: Number,
  lng: Number,
});

const Pickup = mongoose.model('Pickup', pickupSchema);
const Warehouse = mongoose.model('Warehouse', warehouseSchema);

app.get('/api/pickups', async (req, res) => {
  try {
    const pickups = await Pickup.find();
    res.json(pickups);
  } catch (err) {
    res.status(500).json({ message: "Error fetching pickups", error: err });
  }
});


app.post('/api/pickups', async (req, res) => {
  try {
    const pickup = new Pickup(req.body);
    await pickup.save();
    res.status(201).json({ message: "Pickup saved", data: pickup });
  } catch (err) {
    res.status(400).json({ message: "Error saving pickup", error: err });
  }
});

app.get('/api/warehouse', async (req, res) => {
  try {
    const warehouse = await Warehouse.findOne();
    res.json(warehouse);
  } catch (err) {
    res.status(500).json({ message: "Error fetching warehouse", error: err });
  }
});

app.post('/api/warehouse', async (req, res) => {
  try {
    const warehouse = new Warehouse(req.body);
    await warehouse.save();
    res.status(201).json({ message: "Warehouse saved", data: warehouse });
  } catch (err) {
    res.status(400).json({ message: "Error saving warehouse", error: err });
  }
});

app.listen(PORT, () => {
  console.log(` Server running at http://localhost:${PORT}`);
});
