// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/PriceFeed.sol";
import "../src/CollateralizationMonitor.sol";

contract PriceFeedTest is Test {
    PriceFeed priceFeed;
    address forwarder = address(0x1234);
    address attacker = address(0xBEEF);

    function setUp() public {
        priceFeed = new PriceFeed(forwarder);
    }

    function test_RejectsZeroForwarder() public {
        vm.expectRevert(abi.encodeWithSignature("InvalidForwarderAddress()"));
        new PriceFeed(address(0));
    }

    function test_OnlyForwarderCanCallOnReport() public {
        bytes memory report = abi.encodeWithSelector(
            bytes4(keccak256("updatePrice(uint256,uint256)")),
            100e8,
            block.timestamp
        );

        // Attacker cannot call
        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSignature("InvalidSender(address,address)", attacker, forwarder));
        priceFeed.onReport("", report);

        // Forwarder can call
        vm.prank(forwarder);
        priceFeed.onReport("", report);

        (uint256 price, uint256 ts) = priceFeed.getLatestPrice();
        assertEq(price, 100e8);
        assertEq(ts, block.timestamp);
    }

    function test_OwnerCanUpdateForwarder() public {
        address newForwarder = address(0x5678);
        priceFeed.setForwarderAddress(newForwarder);
        assertEq(priceFeed.getForwarderAddress(), newForwarder);
    }

    function test_NonOwnerCannotUpdateForwarder() public {
        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSignature("NotOwner()"));
        priceFeed.setForwarderAddress(attacker);
    }

    function test_SupportsInterface() public view {
        assertTrue(priceFeed.supportsInterface(type(IReceiver).interfaceId));
        assertTrue(priceFeed.supportsInterface(type(IERC165).interfaceId));
    }
}

contract CollateralizationMonitorTest is Test {
    CollateralizationMonitor monitor;
    address forwarder = address(0x1234);
    address attacker = address(0xBEEF);

    function setUp() public {
        monitor = new CollateralizationMonitor(forwarder);
    }

    function test_OnlyForwarderCanCallOnReport() public {
        bytes memory report = abi.encodeWithSelector(
            bytes4(keccak256("updateCollateral(uint256,uint256,uint256,uint256,bool)")),
            100e8, 150e8, 150, block.timestamp, true
        );

        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSignature("InvalidSender(address,address)", attacker, forwarder));
        monitor.onReport("", report);

        vm.prank(forwarder);
        monitor.onReport("", report);

        CollateralizationMonitor.CollateralData memory data = monitor.getLatestData();
        assertEq(data.price, 100e8);
        assertEq(data.reserves, 150e8);
        assertEq(data.ratio, 150);
        assertTrue(data.isHealthy);
    }

    function test_OnlyOwnerCanSetMinRatio() public {
        monitor.setMinRatio(150);
        assertEq(monitor.minRatio(), 150);

        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSignature("NotOwner()"));
        monitor.setMinRatio(200);
    }

    event ThresholdBreached(uint256 ratio, uint256 minRatio);

    function test_ThresholdBreachedEvent() public {
        bytes memory report = abi.encodeWithSelector(
            bytes4(keccak256("updateCollateral(uint256,uint256,uint256,uint256,bool)")),
            100e8, 100e8, 100, block.timestamp, false
        );

        vm.prank(forwarder);
        vm.expectEmit(true, true, false, true);
        emit ThresholdBreached(100, 120);
        monitor.onReport("", report);
    }
}
