// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/PriceFeed.sol";

contract DeployPriceFeed is Script {
    // Forwarder addresses per network
    // Sepolia MockForwarder (simulation): 0x15fC6ae953E024d975e77382eEeC56A9101f9F88
    // Sepolia KeystoneForwarder (production): 0xF8344CFd5c43616a4366C34E3EEE75af79a74482

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address forwarderAddress = vm.envAddress("FORWARDER_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        PriceFeed priceFeed = new PriceFeed(forwarderAddress);

        console.log("PriceFeed deployed to:", address(priceFeed));
        console.log("Forwarder address:", forwarderAddress);

        vm.stopBroadcast();
    }
}
