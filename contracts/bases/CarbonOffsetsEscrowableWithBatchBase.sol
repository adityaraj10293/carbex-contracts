// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import './CarbonOffsetsBase.sol';
import './CarbonOffsetsWithBatchBaseTypes.sol';
import './CarbonOffsetsWithBatchBase.sol';
import '../libraries/Errors.sol';

/// @notice Base contract that can be reused between different TCO2
/// implementations that need to work with batch NFTs
abstract contract CarbonOffsetsEscrowableWithBatchBase is
    IERC721Receiver,
    CarbonOffsetsWithBatchBase
{
    // ----------------------------------------
    //       Events
    // ----------------------------------------

    event DetokenizationRequested(
        address indexed user,
        uint256 amount,
        uint256 indexed requestId,
        uint256[] batchIds
    );
    event DetokenizationReverted(uint256 indexed requestId);
    event DetokenizationFinalized(uint256 indexed requestId);

    event RetirementRequested(
        address indexed user,
        uint256 indexed requestId,
        CreateRetirementRequestParams params
    );
    event RetirementReverted(uint256 indexed requestId);
    event RetirementFinalized(uint256 indexed requestId);

    // ----------------------------------------
    //       Admin functions
    // ----------------------------------------

    /// @notice Finalize a detokenization request
    /// @param requestId The request id in the escrow contract that
    /// tracks the detokenization request
    function finalizeDetokenization(uint256 requestId)
        external
        whenNotPaused
        onlyWithRole(DETOKENIZER_ROLE)
    {
        address escrow = IContractRegistry(contractRegistry)
            .CarbonOffsetsEscrowAddress();

        // Fetch batch NFT IDs from escrow request
        DetokenizationRequest memory request = ICarbonOffsetsEscrow(
            escrow
        ).detokenizationRequests(requestId);

        _updateBatchStatuses(
            request.batchTokenIds,
            BatchStatus.DetokenizationFinalized
        );
        // Finalize escrow request
        ICarbonOffsetsEscrow(escrow).finalizeDetokenizationRequest(
            requestId
        );

        emit DetokenizationFinalized(requestId);
    }

    /// @notice Revert a detokenization request
    /// @param requestId The request id in the escrow contract that
    /// tracks the detokenization request
    function revertDetokenization(uint256 requestId)
        external
        whenNotPaused
        onlyWithRole(DETOKENIZER_ROLE)
    {
        address escrow = IContractRegistry(contractRegistry)
            .CarbonOffsetsEscrowAddress();

        // Fetch batch NFT IDs from escrow request
        DetokenizationRequest memory request = ICarbonOffsetsEscrow(
            escrow
        ).detokenizationRequests(requestId);

        _updateBatchStatuses(request.batchTokenIds, BatchStatus.Confirmed);

        // Mark escrow request as reverted
        ICarbonOffsetsEscrow(escrow).revertDetokenizationRequest(
            requestId
        );

        emit DetokenizationReverted(requestId);
    }

    /// @notice Finalize a retirement request
    /// @param requestId The request id in the escrow contract that
    /// tracks the retirement request
    function finalizeRetirement(uint256 requestId)
        external
        whenNotPaused
        onlyWithRole(RETIREMENT_ROLE)
    {
        address escrow = IContractRegistry(contractRegistry)
            .CarbonOffsetsEscrowAddress();

        // Fetch batch NFT IDs from escrow request
        RetirementRequest memory request = ICarbonOffsetsEscrow(escrow)
            .retirementRequests(requestId);

        _updateBatchStatuses(
            request.batchTokenIds,
            BatchStatus.RetirementFinalized
        );
        // Finalize escrow request
        ICarbonOffsetsEscrow(escrow).finalizeRetirementRequest(requestId);

        emit RetirementFinalized(requestId);
    }

    /// @notice Revert a retirement request
    /// @param requestId The request id in the escrow contract that
    /// tracks the retirement request
    function revertRetirement(uint256 requestId)
        external
        whenNotPaused
        onlyWithRole(RETIREMENT_ROLE)
    {
        address escrow = IContractRegistry(contractRegistry)
            .CarbonOffsetsEscrowAddress();

        // Fetch batch NFT IDs from escrow request
        RetirementRequest memory request = ICarbonOffsetsEscrow(escrow)
            .retirementRequests(requestId);

        _updateBatchStatuses(request.batchTokenIds, BatchStatus.Confirmed);

        // Mark escrow request as reverted
        ICarbonOffsetsEscrow(escrow).revertRetirementRequest(requestId);

        emit RetirementReverted(requestId);
    }

    // ----------------------------------------
    //       Permissionless functions
    // ----------------------------------------

    /// @notice Request a detokenization of a batch NFT
    /// @param tokenIds One or more batches to detokenize
    /// @param amount The amount of TCO2 to detokenize
    /// Currently the amount must match the batch quantity
    /// @return The ID of the request in the escrow contract
    /// @dev This function is permissionless and can be called
    /// by anyone
    function requestDetokenization(uint256[] calldata tokenIds, uint256 amount)
        external
        whenNotPaused
        returns (uint256)
    {
        address escrow = IContractRegistry(contractRegistry)
            .CarbonOffsetsEscrowAddress();
        uint256 totalAmount = _updateBatchStatuses(
            tokenIds,
            BatchStatus.DetokenizationRequested
        );

        // Current requirement is that the total batch quantity matches the provided
        // amount. In the future this requirement should be removed in favor of
        // performing batch splitting.
        require(amount == totalAmount, Errors.TCO2_BATCH_AMT_MISMATCH);

        // Create escrow contract request
        require(approve(escrow, amount), Errors.TCO2_APPROVAL_AMT_FAILED);
        uint256 requestId = ICarbonOffsetsEscrow(escrow)
            .createDetokenizationRequest(_msgSender(), amount, tokenIds);

        emit DetokenizationRequested(_msgSender(), amount, requestId, tokenIds);

        return requestId;
    }

    function requestRetirement(CreateRetirementRequestParams calldata params)
        external
        whenNotPaused
        returns (uint256 requestId)
    {
        address escrowAddress = IContractRegistry(contractRegistry)
            .CarbonOffsetsEscrowAddress();
        uint256 totalAmount = _updateBatchStatuses(
            params.tokenIds,
            BatchStatus.RetirementRequested
        );

        // Current requirement is that the total batch quantity matches the provided
        // amount. In the future this requirement should be removed in favor of
        // performing batch splitting.
        require(params.amount == totalAmount, Errors.TCO2_BATCH_AMT_MISMATCH);

        // Create escrow contract request
        require(
            approve(escrowAddress, params.amount),
            Errors.TCO2_APPROVAL_AMT_FAILED
        );
        requestId = ICarbonOffsetsEscrow(escrowAddress)
            .createRetirementRequest(_msgSender(), params);

        emit RetirementRequested(_msgSender(), requestId, params);

        return requestId;
    }

    // ----------------------------------------
    //       Internal functions
    // ----------------------------------------

    function _updateBatchStatuses(uint256[] memory tokenIds, BatchStatus status)
        internal
        returns (uint256)
    {
        address batchNFT = IContractRegistry(contractRegistry)
            .carbonOffsetBatchesAddress();
        uint256 totalAmount;
        // Loop through batches in the request and set them to the batch status provided
        // while keeping track of the total amount to transfer from the user
        uint256 batchIdLength = tokenIds.length;
        //slither-disable-next-line uninitialized-local
        for (uint256 i; i < batchIdLength; ) {
            uint256 tokenId = tokenIds[i];
            (, uint256 batchAmount, ) = _getNormalizedDataFromBatch(
                batchNFT,
                tokenId
            );
            totalAmount += batchAmount;
            // Transition batch status to updated status
            ICarbonOffsetBatches(batchNFT)
                .setStatusForDetokenizationOrRetirement(tokenId, status);
            unchecked {
                ++i;
            }
        }
        return totalAmount;
    }

    function retireAndMintCertificateForEntity(
        address retiringEntity,
        CreateRetirementRequestParams calldata params
    ) external virtual onlyEscrow {
        _retireAndMintCertificate(retiringEntity, params);
    }
}
