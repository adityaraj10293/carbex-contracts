// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED



pragma solidity 0.8.14;

/// @dev Separate storage contract to improve upgrade safety
abstract contract CarbonOffsetsStorage {
    uint256 internal _projectVintageTokenId;
    address public contractRegistry;

    mapping(address => uint256) public minterToId;
    /// @dev deprecated field; retirements are now tracked
    /// as events in the RetirementCertificatesStorage contract
    mapping(address => uint256) internal retiredAmount;
}
