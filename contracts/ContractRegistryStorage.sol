// SPDX-FileCopyrightText: 2021  Labs
//
// SPDX-License-Identifier: UNLICENSED


pragma solidity 0.8.14;

abstract contract ContractRegistryStorageLegacy {
    address internal _carbonOffsetBatchesAddress;
    address internal _carbonProjectsAddress;
    address internal _carbonProjectVintagesAddress;
    //slither-disable-next-line uninitialized-state,constable-states
    address internal DEPRECATED_CarbonOffsetsFactoryAddress;
    address internal _retirementCertificatesAddress;
    mapping(address => bool) public projectVintageERC20Registry;
}

abstract contract ContractRegistryStorageV1 {
    /// @notice map of standard registries to tco2 factory addresses
    mapping(string => address) public CarbonOffsetFactories;
    /// @dev make it easy to get the supported standard registries
    string[] internal standardRegistries;
}

abstract contract ContractRegistryStorageV2 {
    address internal _CarbonOffsetsEscrowAddress;
}

abstract contract ContractRegistryStorage is
    ContractRegistryStorageV1,
    ContractRegistryStorageV2
{}
