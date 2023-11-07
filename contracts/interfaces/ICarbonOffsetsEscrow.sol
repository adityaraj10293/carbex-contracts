// SPDX-FileCopyrightText: 2023  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import '../CarbonOffsetsEscrowTypes.sol';
import '../bases/CarbonOffsetsWithBatchBaseTypes.sol';

interface ICarbonOffsetsEscrow {
    function createDetokenizationRequest(
        address user,
        uint256 amount,
        uint256[] calldata batchTokenIds
    ) external returns (uint256);

    function createRetirementRequest(
        address user,
        CreateRetirementRequestParams calldata params
    ) external returns (uint256);

    function finalizeDetokenizationRequest(uint256 requestId) external;

    function finalizeRetirementRequest(uint256 requestId) external;

    function revertDetokenizationRequest(uint256 requestId) external;

    function revertRetirementRequest(uint256 requestId) external;

    function detokenizationRequests(uint256 requestId)
        external
        view
        returns (DetokenizationRequest memory);

    function retirementRequests(uint256 requestId)
        external
        view
        returns (RetirementRequest memory);
}
