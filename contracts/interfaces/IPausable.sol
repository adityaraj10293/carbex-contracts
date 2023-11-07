// SPDX-FileCopyrightText: 2022  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

interface IPausable {
    function paused() external view returns (bool);

    function pause() external;

    function unpause() external;
}
