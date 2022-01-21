// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
pragma experimental ABIEncoderV2;

import '@solidstate/contracts/factory/CloneFactory.sol';
import '../interfaces/ICloneable.sol';

abstract contract Cloneable is ICloneable, CloneFactory {
    event Clone(address indexed from, address indexed cloned);

    function clone() external override returns(address cloned) {
        cloned = _deployClone();
        emit Clone(address(this), cloned);
    }

    function cloneDeterministic(bytes32 salt) external override returns(address cloned) {
        cloned = _deployClone(salt);
        emit Clone(address(this), cloned);
    }

    function predictDeterministicAddress(bytes32 salt) external override view returns(address) {
        return _calculateCloneDeploymentAddress(salt);
    }
}
