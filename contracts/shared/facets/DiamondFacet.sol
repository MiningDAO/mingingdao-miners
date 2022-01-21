// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
pragma experimental ABIEncoderV2;

import '@solidstate/contracts/proxy/diamond/DiamondBaseStorage.sol';
import '@solidstate/contracts/introspection/ERC165.sol';
import '@solidstate/contracts/proxy/diamond/DiamondCuttable.sol';
import '@solidstate/contracts/proxy/diamond/DiamondLoupe.sol';

contract DiamondFacet is DiamondCuttable, DiamondLoupe, ERC165 {
    using ERC165Storage for ERC165Storage.Layout;

    function getFallbackAddress() external view returns (address) {
        return DiamondBaseStorage.layout().fallbackAddress;
    }

    function setFallbackAddress(address fallbackAddress) external onlyOwner {
        DiamondBaseStorage.layout().fallbackAddress = fallbackAddress;
    }
}
