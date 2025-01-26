const express = require("express");
const app = express();
const mongoose = require("mongoose");
const cors = require('cors');
const bodyParser = require('body-parser');
const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');
require('dotenv').config();
app.use(bodyParser.json());
app.use(cors());
app.use(express.json());

const mongoUrl = process.env.URL;

mongoose.connect(mongoUrl)
    .then(() => {
        console.log("Database Connected");
    })
    .catch((e) => {
        console.error("Error connecting to database:", e);
    });

// Initialize Firebase Admin SDK
const serviceAccount = require('D:/green_credit/backend/htmlapp-fa3bc-firebase-adminsdk-tfivb-2c9717e1e9.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: 'htmlapp-fa3bc.appspot.com' // replace with your Firebase Storage bucket name
});

const bucket = admin.storage().bucket();

app.post('/authenticate', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).send({ status: "error", data: "Email and password are required" });
    }

    try {
        const collections = await mongoose.connection.db.listCollections().toArray();
        for (const collectionInfo of collections) {
            const collection = mongoose.connection.collection(collectionInfo.name);
            const user = await collection.findOne({ email, password });

            if (user) {
                return res.send({ status: "ok", data: user });
            }
        }
        res.status(401).send({ status: "error", data: "Invalid authentication" });
    } catch (error) {
        res.status(500).send({ status: "error", data: error.message });
    }
});

app.get('/approvedCredits/:collectionName', async (req, res) => {
const { collectionName } = req.params;

try {
    const UserCollection = mongoose.connection.collection(collectionName);
    const approvedApplications = await UserCollection.find({ applicationStatus: "Approved" }).toArray();

    if (!approvedApplications || approvedApplications.length === 0) {
        return res.status(404).send({ status: "error", data: "No approved applications found" });
    }

    const totalApprovedCredits = approvedApplications.reduce((sum, application) => sum + parseInt(application.creditAmount),0);

    res.send({ status: "ok", data: totalApprovedCredits });
} catch (error) {
    res.status(500).send({ status: "error", data: error.message });
}
});

app.post('/generate_bill', async (req, res) => {
    const { name, contactNumber, email, address, products } = req.body;
    const currentDate = new Date().toLocaleDateString();

    // Generate a random 5-digit number for unique file naming
    const randomFiveDigits = Math.floor(10000 + Math.random() * 90000);
    const fileName = `${name.replace(/\s+/g, '_')}_${randomFiveDigits}.pdf`;
    const filePath = path.join(__dirname, fileName);

    const doc = new PDFDocument({ margin: 50 });

    // Pipe the document to a file
    const writeStream = fs.createWriteStream(filePath);
    doc.pipe(writeStream);

    // Add document content
    doc
        .fontSize(20)
        .text('Order Details', {
            align: 'center',
        });

    doc.moveDown();

    const tableTop = 150;
    const col1X = 50;
    const col2X = 150;
    const col3X = 250;
    const col4X = 350;
    const col5X = 450;
    const colWidth = 100;

    // Table Headers
    doc
        .fontSize(12)
        .text('S No.', col1X, tableTop, { width: colWidth, align: 'center' })
        .text('Description', col2X, tableTop, { width: colWidth })
        .text('Quantity Ordered', col3X, tableTop, { width: colWidth, align: 'center' })
        .text('Credits per unit', col4X, tableTop, { width: colWidth, align: 'center' })
        .text('Credits', col5X, tableTop, { width: colWidth, align: 'center' });

    doc
        .moveTo(col1X, tableTop + 20)
        .lineTo(700, tableTop + 20)
        .stroke();

    let itemTop = tableTop + 30;
    let totalSum = 0;

    // Add each product to the table
    products.forEach((product, index) => {
        const { description, quantity, costPerUnit } = product;
        const totalCost = quantity * costPerUnit;
        totalSum += totalCost;

        doc
            .text(index + 1, col1X, itemTop, { width: colWidth, align: 'center' })
            .text(description, col2X, itemTop, { width: colWidth })
            .text(quantity, col3X, itemTop, { width: colWidth, align: 'center' })
            .text(costPerUnit.toFixed(2), col4X, itemTop, { width: colWidth, align: 'center' })
            .text(totalCost.toFixed(2), col5X, itemTop, { width: colWidth, align: 'center' });

        itemTop += 20;
        doc
            .moveTo(col1X, itemTop)
            .lineTo(700, itemTop)
            .stroke();
    });

    const shippingTop = itemTop + 20;

    // Shipping Address
    doc
        .fontSize(12)
        .text('Shipping Address:', col1X, shippingTop)
        .text(address, col1X, shippingTop + 20);

    const footerTop = shippingTop + 40;

    // Customer Details
    doc
        .fontSize(12)
        .text('Total Credits:', col1X, footerTop)
        .text(totalSum.toFixed(2), col5X, footerTop, { width: colWidth, align: 'center' });

    doc
        .fontSize(12)
        .text('Customer Details:', col1X, footerTop + 20)
        .text(`Name: ${name}`, col1X, footerTop + 40)
        .text(`Contact Number: ${contactNumber}`, col1X, footerTop + 60)
        .text(`Email: ${email}`, col1X, footerTop + 80);

    // Footer
    doc
        .fontSize(10)
        .text(`Ship Date: ${currentDate}`, col1X, footerTop + 100)
        .moveDown()
        .text('Controller of Green credits issues this', col1X, footerTop + 120, { width: 500 });

    // Finalize the PDF and end the stream
    doc.end();

    writeStream.on('finish', async () => {
        try {
            // Upload to Firebase Storage
            await bucket.upload(filePath, {
                destination: `order_bills/${fileName}`,
                public: true,
                metadata: {
                    cacheControl: 'public, max-age=31536000',
                },
            });

            // Get the public URL of the file
            const file = bucket.file(`order_bills/${fileName}`);
            const url = `https://storage.googleapis.com/${bucket.name}/${file.name}`;

            // Delete the local file after upload
            fs.unlinkSync(filePath);

            // Store the URL in MongoDB
            const orderDetailsCollection = mongoose.connection.collection("order_details");
            await orderDetailsCollection.insertOne({
                name,
                contactNumber,
                email,
                address,
                products,
                pdfUrl: url,
                date: currentDate,
            });

            // Send the URL in the response
            res.send({ status: "ok", data: { url } });

        } catch (error) {
            console.error('Error uploading to Firebase Storage or saving to MongoDB:', error);
            res.status(500).send('Error generating the bill');
        }
    });

    writeStream.on('error', (err) => {
        console.error('Error writing the PDF file:', err);
        res.status(500).send('Error generating the bill');
    });
});

app.listen(5001, () => {
    console.log("Server Running");
});
