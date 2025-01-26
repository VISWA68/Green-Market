// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GreenCreditPlatform {
    address private owner;

    constructor(address initialOwner) {
        owner = initialOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    struct TransactionDetail {
        string applicantName;
        string email;
        uint amountOfCredits;
    }

    TransactionDetail[] public transactions;

    event ActivityApproved(
        uint indexed transactionId,
        string applicantName,
        string email,
        uint amountOfCredits
    );

    function approveActivity(
        string memory applicantName,
        string memory email,
        uint amountOfCredits
    ) public onlyOwner {
        TransactionDetail memory newTransaction = TransactionDetail({
            applicantName: applicantName,
            email: email,
            amountOfCredits: amountOfCredits
        });
        transactions.push(newTransaction);
        uint transactionId = transactions.length - 1;
        emit ActivityApproved(transactionId, applicantName, email, amountOfCredits);
    }

    function getTransaction(uint transactionId)
        public
        view
        returns (string memory, string memory, uint)
    {
        require(transactionId < transactions.length, "Invalid transaction ID");
        TransactionDetail memory transaction = transactions[transactionId];
        return (transaction.applicantName, transaction.email, transaction.amountOfCredits);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
