// SPDX-FileCopyrightText: 2023  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import './PoolFilter.sol';

contract NatureCarbonTonneFilter is PoolFilter {
    // ----------------------------------------
    //      Constants
    // ----------------------------------------

    string public constant VERSION = '1.0.0';

    // ----------------------------------------
    //      Upgradable related functions
    // ----------------------------------------

    function initialize() external virtual initializer {
        __PoolFilter_init();
    }
}
