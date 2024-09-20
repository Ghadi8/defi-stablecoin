// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Decentralized Stablecoin
 * @author Ghadi Mhawej
 * @dev A decentralized stablecoin that is pegged to the US Dollar. Exogenous Collateral is used to back the stablecoin.
 * @notice This contract is meant to be governed by the DSCEngine. It is just an ERC20 implementation of the stablecoin system.
 */
contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin__MustBeGreaterThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin_CannotMintToZeroAddress();

    constructor() ERC20("Decentralized Stablecoin", "DSC") {}

    function burn(uint256 amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (amount <= 0) {
            revert DecentralizedStableCoin__MustBeGreaterThanZero();
        }

        if (amount > balance) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }
        super.burn(amount);
    }

    function mint(address to, uint256 amount) external onlyOwner returns (bool) {
        if (to == address(0)) {
            revert DecentralizedStableCoin_CannotMintToZeroAddress();
        }

        if (amount <= 0) {
            revert DecentralizedStableCoin__MustBeGreaterThanZero();
        }

        _mint(to, amount);
        return true;
    }
}
