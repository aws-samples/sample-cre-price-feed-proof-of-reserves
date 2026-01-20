// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC165} from "./IERC165.sol";
import {IReceiver} from "./IReceiver.sol";

/// @title ReceiverTemplate - Abstract receiver with forwarder validation
/// @notice Provides security checks for receiving workflow reports from KeystoneForwarder
abstract contract ReceiverTemplate is IReceiver {
    address private s_forwarderAddress;
    address private s_owner;

    error InvalidForwarderAddress();
    error InvalidSender(address sender, address expected);
    error NotOwner();

    event ForwarderAddressUpdated(address indexed previousForwarder, address indexed newForwarder);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        if (msg.sender != s_owner) revert NotOwner();
        _;
    }

    constructor(address _forwarderAddress) {
        if (_forwarderAddress == address(0)) revert InvalidForwarderAddress();
        s_forwarderAddress = _forwarderAddress;
        s_owner = msg.sender;
        emit ForwarderAddressUpdated(address(0), _forwarderAddress);
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function getForwarderAddress() external view returns (address) {
        return s_forwarderAddress;
    }

    function owner() external view returns (address) {
        return s_owner;
    }

    function setForwarderAddress(address _forwarder) external onlyOwner {
        address previous = s_forwarderAddress;
        s_forwarderAddress = _forwarder;
        emit ForwarderAddressUpdated(previous, _forwarder);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        address previous = s_owner;
        s_owner = newOwner;
        emit OwnershipTransferred(previous, newOwner);
    }

    function onReport(bytes calldata, bytes calldata report) external override {
        if (msg.sender != s_forwarderAddress) {
            revert InvalidSender(msg.sender, s_forwarderAddress);
        }
        _processReport(report);
    }

    function _processReport(bytes calldata report) internal virtual;

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IReceiver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }
}
