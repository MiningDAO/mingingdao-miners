// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import "./DeMineAgent.sol";

/// @author Shu Dong
contract DeMineNFT is
    ERC1155Upgradeable,
    OwnableUpgradeable,
    IERC2981Upgradeable
{
    // Events
    event NewPool(uint128 indexed, address indexed, uint256, string);
    event RewardSet(uint128 indexed, address indexed, uint256, uint256);
    event RewarderSet(address indexed, address indexed);
    event Cashout(address indexed, address indexed, address indexed, uint256);
    event TokenRoyaltySet(address indexed, uint256);

    address private _agent;
    address private _rewardToken;
    uint128 private _cycle;
    uint128 private _pool;

    address private _royaltyRecipient;
    uint16 private _royaltyBps; // EIP2981

    struct Cycle {
        uint256 supply;
        uint256 rewardPerToken;
    }
    mapping(uint128 => Cycle) private _cycles;

    function initialize(
        string memory uri,
        address royaltyRecipient,
        uint16 royaltyBps,
        address agentContract
    ) public initializer {
        __Ownable_init();
        __ERC1155_init(uri);
        _royaltyRecipient = royaltyRecipient;
        _royaltyBps = royaltyBps;
        _agent = agentContract;
    }

    constructor() initializer {}

    function newPool(
        string calldata info,
        uint128 startCycle,
        uint128 numCycles,
        uint256[] calldata supplies,
        uint256 costPerToken,
        address issuer
    ) external onlyOwner {
        require(
            supplies.length == numCycles,
            "DeMineNFT: supply array length mismatch"
        );
        require(
            startCycle > _cycle + 3,
            "DeMineNFT: startCycle too early"
        );
        _pool += 1;
        uint256[] memory ids = new uint256[](numCycles);
        for (uint128 i = 0; i < numCycles; i++) {
            ids[i] = (uint256(_pool) << 128) + startCycle + i;
            _cycles[startCycle + i].supply += supplies[i];
        }
        DeMineAgent(_agent).setPool(
            _pool, issuer, costPerToken
        );
        _mintBatch(_agent, ids, supplies, "");
        emit NewPool(_pool, issuer, costPerToken, info);
    }

    function reward(
        address rewarder,
        uint128 rewarded
    ) external onlyOwner {
        _cycle += 1;
        _cycles[_cycle].rewardPerToken = rewarded / _cycles[_cycle].supply;
        bool success = IERC20(
            _rewardToken
        ).transferFrom(
            rewarder,
            address(this),
            _cycles[_cycle].rewardPerToken * _cycles[_cycle].supply
        );
        require(success, "DeMineNFT: failed to transfer reward");
        emit RewardSet(
            _cycle,
            rewarder,
            _cycles[_cycle].rewardPerToken,
            _cycles[_cycle].supply
        );
    }

    function cashout(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts
    ) external returns(uint256) {
        _burnBatch(from, ids, amounts);
        uint256 totalReward;
        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint128 cycle = uint128(id);
            require(
                cycle < _cycle,
                "DeMineNFT: unrewarded cycle"
            );
            totalReward += amounts[i] * _cycles[cycle].rewardPerToken;
        }
        if (totalReward > 0) {
            bool success = IERC20(_rewardToken).transfer(
                to, totalReward
            );
            require(success, "DeMineNFT: failed to withdraw reward");
        }
        return totalReward;
    }

    // view functions
    function treasureSource() external view returns (address) {
        return _rewardToken;
    }

    function agent() external view returns(address) {
        return _agent;
    }

    function cycleInfo(uint128 cycle) external view returns (uint256, uint256) {
        return (
            _cycles[cycle].supply,
            _cycles[cycle].rewardPerToken
        );
    }

    // ERC 2981
    function setTokenRoyaltyInfo(
        address recipient,
        uint16 bps
    ) external onlyOwner {
        _royaltyRecipient = recipient;
        _royaltyBps = bps;
        emit TokenRoyaltySet(recipient, bps);
    }

    function royaltyInfo(uint256, uint256 value)
        external
        view
        override
        returns (address, uint256)
    {
        return (_royaltyRecipient, (value * _royaltyBps) / 10000);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155Upgradeable, IERC165Upgradeable)
        returns (bool)
    {
        return
            interfaceId == type(IERC2981Upgradeable).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
