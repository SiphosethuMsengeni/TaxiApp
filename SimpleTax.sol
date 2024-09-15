// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleTax is ERC20 {
    address public immutable fund;
    uint256 public constant TAX_PERCENTAGE = 5;

    constructor(address fund_) ERC20("SimpleTax", "STX") {
        _mint(msg.sender, 1000 * 10 ** decimals());
        fund = fund_;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal  {
        // Ensure we don't tax minting or burning
        if (from != address(0) && to != address(0) && from != fund) {
            uint256 tax = (amount * TAX_PERCENTAGE) / 100;
            uint256 amountAfterTax = amount - tax;

            // Transfer the tax amount to the fund
            super._transfer(from, fund, tax);

            // Transfer the remaining amount to the recipient
            super._transfer(from, to, amountAfterTax);

            // Revert the original transfer call by preventing the normal flow
            revert("Tax deducted and transferred");
        }
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        // Perform custom logic before transfer
        _beforeTokenTransfer(_msgSender(), recipient, amount);
        // This line will never be reached due to revert in _beforeTokenTransfer
        return false;
    }
}
