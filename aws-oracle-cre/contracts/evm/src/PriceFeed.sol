// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./keystone/ReceiverTemplate.sol";

contract PriceFeed is ReceiverTemplate {
    struct PriceData {
        uint256 price;
        uint256 timestamp;
    }

    PriceData public latestPrice;

    event PriceUpdated(uint256 price, uint256 timestamp);

    constructor(address _forwarderAddress) ReceiverTemplate(_forwarderAddress) {}

    function getLatestPrice() external view returns (uint256, uint256) {
        return (latestPrice.price, latestPrice.timestamp);
    }

    function _processReport(bytes calldata report) internal override {
        require(report.length >= 4, "Report too short");
        bytes calldata params = report[4:];
        (uint256 price, uint256 timestamp) = abi.decode(params, (uint256, uint256));
        latestPrice = PriceData(price, timestamp);
        emit PriceUpdated(price, timestamp);
    }
}
