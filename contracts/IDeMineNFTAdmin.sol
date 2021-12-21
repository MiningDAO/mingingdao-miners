// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

interface IDeMineNFTAdmin {
    function redeem(address, uint256[] calldata, uint256[] calldata) external;
}
