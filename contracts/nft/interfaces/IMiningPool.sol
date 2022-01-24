// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
pragma experimental ABIEncoderV2;

import '@solidstate/contracts/token/ERC1155/IERC1155Internal.sol';

/**
 * @dev Interface for DeMineNFT for DeMineAgent
 */
interface IMiningPool is IERC1155Internal {
    /**
     * @dev shrink mining pool by burning token not mined
     * @param ids List of token ids to burn
     */
    function shrink(uint[] memory ids) external;

    /**
     * @dev burn tokens in batch and cashout income
     * @param ids List of token ids to alchemize
     * @return total income
     */
    function alchemize(uint[] memory ids) external returns(uint);

    function getMining() external view returns(uint);

    function treasureSource() external view returns(address);
}
