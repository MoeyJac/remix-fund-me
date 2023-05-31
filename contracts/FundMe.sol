//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUSD = 50 * 1e18;

    address[] funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;
    
    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "Sender is not the owner.");
        _;
    }

    function fund() external payable {
        // Want to be able to specify a minimum amount for deposit
         require(msg.value.getConversionRate() >= minimumUSD, "Didnt meet minimum deposit amount");
         funders.push(msg.sender);
         addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner() {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            // Reset funder amount to 0
            addressToAmountFunded[funder] = 0;
        }
        // Reset the funders list
        funders = new address[](0);

        // Withdraw funds

        // transfer - reverts if it fails automatically
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);

        // send - returns bool if success/fail. Does NOT fail automatically
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        // call - can call a function and return success + data from called function
        // most used function to transfer ethereum 
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

}