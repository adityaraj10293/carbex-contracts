// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED



pragma solidity 0.8.14;

enum BatchStatus {
    Pending, // 0
    Rejected, // 1
    Confirmed, // 2
    DetokenizationRequested, // 3
    DetokenizationFinalized, // 4
    RetirementRequested, // 5
    RetirementFinalized // 6
}
