pragma solidity ^0.5.5;
// owner funciton / sender to be the travel agent - ownable
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";
// Payment Piece - customer makes payment to agent this can be in cash, credit card, crypto etc. Agent funds the escrow from which payment to others in the value chain is made.
// Trust Account for payments from Customer to Agent to be kept in - Escrow with conditional terms. There are two ways to fund the Escrow, 1. Customer funds it directly or 2. Agent funds it.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/payment/escrow/ConditionalEscrow.sol";
//(Pull Payment) Deposit to the four accounts
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/payment/PullPayment.sol";
 //Refund Escrow when services are not delivered / cancelled or chages are made to the travel.
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/payment/escrow/RefundEscrow.sol";
 //Rules for when funds are to be sent, date / time / delivery etc. We are proposing TimelockController. //Segment information??- flight, hotel, car, rental etc.
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/governance/TimelockController.sol";
// A contract is initiated between Customer and the value chain.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
 //(Pull Payment) Deposit to the four accounts
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/payment/PullPayment.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/payment/PaymentSplitter.sol";

contract JohnSmith {
  address _owner = 0xa8Ae4df925966a5cE2Ea2A877196472b0d31BC04; //This is account of John Smith;
  address payable account_zero; //funded kovan // account zero is the travel agent or the escrow account
  address payable account_one; // account one is the airline
  address payable account_two; //funded kovan // account two is the hotel
  address payable account_three; //funded kovan& ropsten  // account three is the rental car

 // last to withdraw variables
  address public last_to_withdraw;
  uint public last_withdraw_block;
  uint public last_withdraw_amount;

  // last to deposit variables
  address public last_to_deposit;
  uint public last_deposit_block;
  uint public last_deposit_amount;
  
  constructor(address payable _zero, address payable _one, address payable _two, address payable _three) public {
      account_zero = _zero;
      account_one = _one;
      account_two =  _two;
      account_three = _three;
  }

  function withdraw(uint amount) public {
    require(msg.sender == account_zero);

    // check if sender is last to withdraw, and update if they were not
    if (last_to_withdraw != msg.sender) {
      last_to_withdraw = msg.sender;
    }

    // update last to withdraw information
    last_withdraw_block = block.number;
    last_withdraw_amount = amount;

    msg.sender.transfer(amount);
  }

  function deposit() public payable {

    // check if sender is last to deposit, and update if they were not
    if (last_to_deposit != msg.sender) {
      last_to_deposit = msg.sender;
    }

    // update last to deposit information
    last_deposit_block = block.number;
    last_deposit_amount = msg.value;
  }
    function () external payable {}
  }
      