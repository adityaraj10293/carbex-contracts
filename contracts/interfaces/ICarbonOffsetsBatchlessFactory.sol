// SPDX-FileCopyrightText: 2022  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import './ICarbonOffsetsFactory.sol';

interface ICarbonOffsetsBatchlessFactory {
    function canMint(address _user) external view returns (bool);
}
