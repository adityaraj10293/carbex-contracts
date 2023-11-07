// SPDX-FileCopyrightText: 2023  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

library Strings {
    function equals(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return
            (bytes(a).length == bytes(b).length) &&
            (keccak256(bytes(a)) == keccak256(bytes(b)));
    }
}
