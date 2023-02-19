// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";

/// @title A sample ERC20 contract
/// @notice Ownable checks have been stripped for testing convinience, not to be used in production
/// @notice Permit extension for easier token transfers
/// @notice Just a sample contract borrowed from openzeppelins wizard, open mint function for testing convenience. Default decimals are 18
/// @dev Default decimals are 18
contract SampleToken is Initializable, ERC20Upgradeable, ERC20PermitUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC20_init("SampleToken", "STK");
        __ERC20Permit_init("SampleToken");
        __UUPSUpgradeable_init();
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
    {}
}