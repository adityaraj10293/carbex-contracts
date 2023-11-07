// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import '../CarbonOffsetBatchesTypes.sol';

interface ICarbonOffsetBatches {
    function getConfirmationStatus(uint256 tokenId)
        external
        view
        returns (BatchStatus);

    function getBatchNFTData(uint256 tokenId)
        external
        view
        returns (
            uint256,
            uint256,
            BatchStatus
        );

    function setStatusForDetokenizationOrRetirement(
        uint256 tokenId,
        BatchStatus newStatus
    ) external;
}
