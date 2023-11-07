// SPDX-FileCopyrightText: 2023  Labs
//
// SPDX-License-Identifier: UNLICENSED



pragma solidity 0.8.14;

struct CreateRetirementRequestParams {
    uint256[] tokenIds;
    uint256 amount;
    string retiringEntityString;
    address beneficiary;
    string beneficiaryString;
    string retirementMessage;
    string beneficiaryLocation;
    string consumptionCountryCode;
    uint256 consumptionPeriodStart;
    uint256 consumptionPeriodEnd;
}
