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
  address _owner = 0x4989AA3D30327eC969dD742fD9A37c38725Ca740; //This is account of John Smith;
  address payable account_zero = 0xF781aa2D099B8262A388CB85833ED5204373Be97; // account zero is the travel agent or the escrow account
  address payable account_one = 0xa8406898777E37E72ea81B997FeDA4df11b54A69; // account one is the airline
  address payable account_two = 0x1Dc236f5534a154Ed0149a0E387969F43Fe4ADcA; // account two is the hotel
  address payable account_three = 0x036B09c899eeade2361baCb2FD31EAb4bEB34f26; // account three is the rental car
// step 1, split the payment across the four accounts,
using SafeMath for uint256;
    event PayeeAdded(address account, uint256 shares);
    event PaymentReleased(address to, uint256 amount);
    event PaymentReceived(address from, uint256 amount);
    uint256 public _totalShares;
    uint256 public _totalReleased;
    mapping(address => uint256) public _shares;
    mapping(address => uint256) public _released;
    address[] public _payees;
 /**
     * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
     * the matching position in the `shares` array.
     *
     * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
     * duplicates in `payees`.
     */
    constructor (address[] memory payees, uint256[] memory shares) public payable {
        // solhint-disable-next-line max-line-length
        require(payees.length == shares.length, "PaymentSplitter: payees and shares length mismatch");
        require(payees.length > 0, "PaymentSplitter: no payees");
        for (uint256 i = 0; i < payees.length; i++) {
            _addPayee(payees[i], shares[i]);
        }
    }
 function _addPayee(address account, uint256 shares_) public {
        require(account != address(0), "PaymentSplitter: account is the zero address");
        require(shares_ > 0, "PaymentSplitter: shares are 0");
        require(_shares[account] == 0, "PaymentSplitter: account already has shares");
        _payees.push(account);
        _shares[account] = shares_;
        _totalShares = _totalShares.add(shares_);
        emit PayeeAdded(account, shares_);
    }
/* @dev Getter for the address of the payee number `index`.
     */
function payee(uint256 index) public view returns (address) {
    return _payees[index];
}
/**
* @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
* total shares and their previous withdrawals.
*/
function release(address payable account) public {
        require(_shares[account] > 0, "PaymentSplitter: account has no shares");
        uint256 totalReceived = address(this).balance.add(_totalReleased);
        uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(_released[account]);
        require(payment != 0, "PaymentSplitter: account is not due payment");
        _released[account] = _released[account].add(payment);
        _totalReleased = _totalReleased.add(payment);
        account.transfer(payment);
        emit PaymentReleased(account, payment);
}
}