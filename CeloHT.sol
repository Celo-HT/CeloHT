// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    CeloHT Payment Contract (FINAL VERSION)
    Assets: cUSD stable token
    Fees: Paid in CELO
    Mobile Wallet Support: Valora, WalletConnect v2
*/

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract CeloHT is Ownable, ReentrancyGuard {
    IERC20 public cUSD;

    event PaymentSent(address indexed from, address indexed to, uint256 amount, string reference);
    event Withdraw(address indexed owner, uint256 amount);

    constructor(address _cUSD) {
        require(_cUSD != address(0), "Invalid cUSD address");
        cUSD = IERC20(_cUSD);
    }

    function sendPayment(
        address to,
        uint256 amount,
        string memory reference
    ) external nonReentrant returns (bool) 
    {
        require(to != address(0), "Invalid recipient");
        require(amount > 0, "Invalid amount");

        uint256 allowed = cUSD.allowance(msg.sender, address(this));
        require(allowed >= amount, "Insufficient allowance");

        bool success = cUSD.transferFrom(msg.sender, to, amount);
        require(success, "Payment failed");

        emit PaymentSent(msg.sender, to, amount, reference);
        return true;
    }

    function withdraw(uint256 amount) external onlyOwner nonReentrant returns (bool) {
        require(amount > 0, "Invalid amount");

        bool success = cUSD.transfer(owner(), amount);
        require(success, "Withdraw failed");

        emit Withdraw(owner(), amount);
        return true;
    }

    function contractBalance() external view returns (uint256) {
        return cUSD.balanceOf(address(this));
    }
}