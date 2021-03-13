# Final_Project_Group3
##
Arbitrable.sol and Arbitrator.sol propose a ERC 792 standard* for Arbitrable and Arbitrator contracts.
###
Arbitrator.sol give rulings.

Arbitrable.sol enforces those rulings.

CentralizedArbitrator.sol implement a centralized arbitrator as an Arbitrator contract.

TwoPartyArbitrable.sol is an abstract contract requiring both parties to pay the arbitration fee and refunding the winning one.

ArbitratedTransaction.sol is a contract allowing ether to be put in escrow, allowing the payer to finalize the transaction, the payee to reimburse part of it and the arbitrator to send the funds to the winning party in case of dispute.
####
  *EIP: 792
  Title: Arbitration Standard
  Status: Draft
  Type: Informational
  Category: ERC
  Author: Clément Lesaege <clement@kleros.io>
  Created: 2017-12-06