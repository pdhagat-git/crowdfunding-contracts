// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol";

pragma solidity ^0.8.0;

/// @title IERC20PermitCombinedUpgradeable interface
/// @notice An interface to combine ERC20 and the permit extension interfaces
interface IERC20PermitCombinedUpgradeable is IERC20PermitUpgradeable, IERC20Upgradeable {}