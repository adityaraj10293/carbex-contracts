// SPDX-FileCopyrightText: 2023  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import './CarbonOffsetsEscrowTypes.sol';

abstract contract CarbonOffsetsEscrowStorageV1 {
    address public contractRegistry;
    // Monotonically increasing request id counter
    uint256 public detokenizationRequestIdCounter;
    // Request id to request data
    mapping(uint256 => DetokenizationRequest) internal _detokenizationRequests;
    // Retirement request id counter
    uint256 public retirementRequestIdCounter;
    // Request id to request data
    mapping(uint256 => RetirementRequest) internal _retirementRequests;
}

abstract contract CarbonOffsetsEscrowStorage is
    CarbonOffsetsEscrowStorageV1
{}
