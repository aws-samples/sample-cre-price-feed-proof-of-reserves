// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./keystone/ReceiverTemplate.sol";

contract CollateralizationMonitor is ReceiverTemplate {
    struct CollateralData {
        uint256 price;
        uint256 reserves;
        uint256 ratio;
        uint256 timestamp;
        bool isHealthy;
    }

    CollateralData public latestData;
    uint256 public minRatio = 120;

    event CollateralUpdated(uint256 price, uint256 reserves, uint256 ratio, bool isHealthy, uint256 timestamp);
    event ThresholdBreached(uint256 ratio, uint256 minRatio);

    constructor(address _forwarderAddress) ReceiverTemplate(_forwarderAddress) {}

    function getLatestData() external view returns (CollateralData memory) {
        return latestData;
    }

    function setMinRatio(uint256 _minRatio) external onlyOwner {
        minRatio = _minRatio;
    }

    function _processReport(bytes calldata report) internal override {
        require(report.length >= 4, "Report too short");
        bytes calldata params = report[4:];
        (uint256 price, uint256 reserves, uint256 ratio, uint256 timestamp, bool isHealthy) =
            abi.decode(params, (uint256, uint256, uint256, uint256, bool));

        latestData = CollateralData(price, reserves, ratio, timestamp, isHealthy);
        emit CollateralUpdated(price, reserves, ratio, isHealthy, timestamp);

        if (!isHealthy) {
            emit ThresholdBreached(ratio, minRatio);
        }
    }
}
