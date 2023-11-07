// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED



pragma solidity 0.8.14;

struct VintageData {
    /// @dev A human-readable string which differentiates this from other vintages in
    /// the same project, and helps build the corresponding TCO2 name and symbol.
    string name;
    uint64 startTime; // UNIX timestamp
    uint64 endTime; // UNIX timestamp
    uint256 projectTokenId;
    uint64 totalVintageQuantity;
    bool isCorsiaCompliant;
    bool isCCPcompliant;
    string coBenefits;
    string correspAdjustment;
    string additionalCertification;
    string uri;
    string registry;
}
