// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import '../interfaces/IContractRegistry.sol';
import '../interfaces/ICarbonProjectVintages.sol';

contract ProjectVintageUtils {
    function checkProjectVintageTokenExists(
        address contractRegistry,
        uint256 tokenId
    ) internal virtual {
        address c = IContractRegistry(contractRegistry)
            .carbonProjectVintagesAddress();
        require(
            ICarbonProjectVintages(c).exists(tokenId),
            'Carbon project vintage does not yet exist'
        );
    }
}
