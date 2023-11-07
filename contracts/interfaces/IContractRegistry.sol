// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

interface IContractRegistry {
    function carbonOffsetBatchesAddress() external view returns (address);

    function carbonProjectsAddress() external view returns (address);

    function carbonProjectVintagesAddress() external view returns (address);

    function CarbonOffsetsFactoryAddress()
        external
        view
        returns (address);

    function CarbonOffsetsFactoryAddress(string memory standardRegistry)
        external
        view
        returns (address);

    function retirementCertificatesAddress() external view returns (address);

    function CarbonOffsetsEscrowAddress() external view returns (address);

    function isValidERC20(address erc20) external view returns (bool);

    function addERC20(address erc20, string memory standardRegistry) external;
}
