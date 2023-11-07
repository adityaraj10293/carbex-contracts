// SPDX-FileCopyrightText: 2023  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import './CarbonOffsetsBase.sol';
import '../interfaces/ICarbonOffsetsFactory.sol';
import '../interfaces/IContractRegistry.sol';

/// @notice
contract CarbonOffsetsBatchlessBase is CarbonOffsetsBase {
    // ----------------------------------------
    //      Events
    // ----------------------------------------

    event Tokenized(
        string indexed identifier,
        uint256 amount,
        address indexed beneficiary
    );

    // ----------------------------------------
    //      Functions
    // ----------------------------------------

    function tokenize(
        string calldata _identifier,
        uint256 _amount,
        uint256 _deadline,
        address _beneficiary
    ) external virtual whenNotPaused onlyWithRole(TOKENIZER_ROLE) {
        require(block.timestamp < _deadline, 'Deadline has passed');
        _mint(_beneficiary, _amount);
        emit Tokenized(_identifier, _amount, _beneficiary);
    }
}
