// SPDX-FileCopyrightText: 2022  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

import {RemoteTokenInformation} from '../CrosschainMessengerStorage.sol';

interface ICrosschainMessenger {
    function sendMessage(
        uint32 destinationDomain,
        address token,
        uint256 amount
    ) external payable;

    function sendMessageWithRecipient(
        uint32 destinationDomain,
        address token,
        uint256 amount,
        address recipient
    ) external payable;

    function remoteTokens(address _token, uint32 _destinationDomain)
        external
        view
        returns (RemoteTokenInformation memory);
}
