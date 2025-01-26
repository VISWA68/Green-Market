const express = require('express');
const { Web3 } = require('web3');
const fs = require('fs');
const path = require('path');
require('dotenv').config();
const cors = require('cors');

const app = express();
app.use(cors());
const port = process.env.PORT || 4000;

// Connect to Ganache
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));

// Load contract JSON file
const contractJSON = JSON.parse(
  fs.readFileSync(path.join(__dirname, 'build/contracts/GreenCreditPlatform.json'), 'utf8')
);
const contractABI = contractJSON.abi;
const contractAddress = '0xa4AB6eA79C3d564223B35ca7E7793E5a32618c32';

const contract = new web3.eth.Contract(contractABI, contractAddress);

app.use(express.json());

// Endpoint to approve activity
app.post('/approveActivity', async (req, res) => {
  try {
    console.log(req.body); // Debug: Log the request body

    const { applicantName, email, amountOfCredits } = req.body;

    if (!applicantName || !email || amountOfCredits === undefined) {
      return res.status(400).json({ error: 'Invalid input data' });
    }

    const accounts = await web3.eth.getAccounts();

    // Convert amountOfCredits from string to BigInt
    const amountOfCreditsBigInt = BigInt(amountOfCredits);

    const result = await contract.methods
      .approveActivity(applicantName, email, amountOfCreditsBigInt)
      .send({ from: accounts[0], gas: 500000 });

    console.log('Approve Activity Result:', result);
    res.json(result.toString());
  } catch (error) {
    console.error('Error in approveActivity:', error); // Detailed error logging
    res.status(500).json({ error: error.message });
  }
});

// Endpoint to get transaction details
app.get('/getTransaction/:transactionId', async (req, res) => {
  try {
    const transactionId = req.params.transactionId;
    const transaction = await contract.methods.getTransaction(transactionId).call();

    // Ensure that all BigInt values are converted to strings
    const result = {
      applicantName: transaction[0],
      email: transaction[1],
      amountOfCredits: transaction[2].toString(), // Convert BigInt to string
    };

    res.json(result.toString());
  } catch (error) {
    console.error('Error in getTransaction:', error); // Detailed error logging
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
