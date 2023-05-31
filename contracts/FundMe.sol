//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUSD = 50 * 1e18;
    
    function fund() public payable {
        // Want to be able to specify a minimum amount for deposit
        // 1. How do we send ETH to this address

         require(getConversionRate(msg.value) >= minimumUSD, "Didnt meet minimum deposit amount");
    }

    function getLatestPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getLatestPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256){
        // Sepolia contract address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();


    }

    // functiion withdraw() public {}

}