// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "contracts/Interfaces/IERC20PermitCombinedUpgradeable.sol";

/// @title A sample crowdfunding contract
/// @notice This contract can be configured to accept crowdfunding through and ERC20 contract
contract Crowdfund is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    /// @notice Token contract instance created using an interface
    IERC20PermitCombinedUpgradeable public token; 

    /// @notice Crowdfunding target amount
    /// @dev Should be in token decimals (ie: wei not eth)
    uint256 public target;

    /// @notice A mapping of pledged funds amount by an address
    mapping(address => uint256) pledgedFunds;

    /// @notice Event marks pledge of events by an address
    event Pledge(address wallet, uint256 amount, uint256 totalPledge);

    /// @notice Event marks withdrawal of pledged funds by an address
    event Withdrawal(address wallet, uint256 amount, uint256 totalPledge);

    // Modifier to check if funding target is not met
    modifier targetPending() {
        require(token.balanceOf(address(this)) < target, "Crowdfund: target already met");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _tokenAddress, uint256 _target) initializer public {
        __UUPSUpgradeable_init();
        __Ownable_init();

        token = IERC20PermitCombinedUpgradeable(_tokenAddress);
        target = _target;
    }

    /// @notice Function to pledge funds to the crowdsource
    /// @dev Pledging is stopped once the the target is met
    /// @param _amount amount to pledge
    /// @param _deadline deadline as defined in ERC20Permit.permit
    /// @param v v as defined in ERC20Permit.permit
    /// @param r r as defined in ERC20Permit.permit
    /// @param s s as defined in ERC20Permit.permit
    function pledgeFunds(uint256 _amount, uint256 _deadline, uint8 v, bytes32 r, bytes32 s) external targetPending {        
        token.permit(msg.sender, address(this), _amount, _deadline, v, r, s);
        token.transferFrom(msg.sender, address(this), _amount);
        
        pledgedFunds[msg.sender] += _amount;

        uint256 totalPledge = token.balanceOf(address(this));
        emit Pledge(msg.sender, _amount, totalPledge);
    }

    /// @notice Function to withdraw pledged funds
    /// @dev Withdrawal is stopped once the the target is met
    /// @param _amount amount to pledge
    function withdrawPledgedFunds(uint256 _amount) external targetPending {        
        require(pledgedFunds[msg.sender] >= _amount, "Crowdfund: cannot withdraw more funds than pledged");
        
        token.transfer(msg.sender, _amount);

        pledgedFunds[msg.sender] -= _amount;

        uint256 totalPledge = token.balanceOf(address(this));
        emit Withdrawal(msg.sender, _amount, totalPledge);
    }

    /// @notice Function to withdraw funds after the target is met
    /// @dev can be only called by contract owner
    /// @param _amount amount to withdraw
    /// @param toAddress address to transfer funds to
    function withdrawFunds(uint256 _amount, address toAddress) external onlyOwner {        
        require(toAddress != address(0), "Crowdfund: toAddress cannot be zero address");

        uint256 balance = token.balanceOf(address(this));
        require(balance >= target, "Crowdfund: crowdfunding target not met");
        require(balance >= _amount, "Crowdfund: cannot withdraw more contract balance");
        
        token.transfer(toAddress, _amount);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
    {}
}