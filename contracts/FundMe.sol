//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUSD = 50 * 1e18;

    address[] funders;
    mapping(address => uint256) public addressToAmountFunded;
    
    function fund() public payable {
        // Want to be able to specify a minimum amount for deposit
         require(msg.value.getConversionRate() >= minimumUSD, "Didnt meet minimum deposit amount");
         funders.push(msg.sender);
         addressToAmountFunded[msg.sender] += msg.value;
    }

    // functiion withdraw() public {}

}