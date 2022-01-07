// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import '@solidstate/contracts/access/OwnableInternal.sol';
import '../utils/ERC20PayableInternal.sol';
import './CycleMetadataStorage.sol';

contract CycleMetadata is ERC20PayableInternal, OwnableInternal {
    using CycleMetadataStorage for CycleMetadataStorage.Layout;

    event Reward(uint128 indexed, address, uint256, uint256);

    function setCycle(uint128 cycle) external onlyOwner {
        CycleMetadataStorage.layout().cycle = cycle;
    }

    function rewardCurrent(address rewarder, uint256 reward) public onlyOwner {
        CycleMetadataStorage.Layout storage l = CycleMetadataStorage.layout();
        uint128 cycle = l.cycle;
        uint256 supply = l.cycles[cycle].supply;
        require(supply > 0, "Reward: cycle supply is 0");

        uint256 rewardPerToken = reward / supply;
        l.cycles[cycle].reward += rewardPerToken;

        payFrom(l.rewardToken, rewarder, address(this), supply * rewardPerToken);
        emit Reward(cycle, rewarder, rewardPerToken, supply);
    }

    function rewardNext(
        address rewarder,
        uint256 reward
    ) external onlyOwner {
        CycleMetadataStorage.layout().next();
        rewardCurrent(rewarder, reward);
    }

    function cycleInfo(
        uint128 cycle
    ) external view returns(uint128, uint256, uint256) {
        CycleMetadataStorage.Layout storage l = CycleMetadataStorage.layout();
        return (l.cycle, l.cycles[cycle].supply, l.cycles[cycle].reward);
    }
}
