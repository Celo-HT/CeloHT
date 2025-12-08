// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    CeloHT Payment Contract
    Purpose: Education, Agent (Cash-in/Cash-out), Reforestation
    Assets: cUSD stable token
    Fees: Paid in CELO (gas)
    Mobile Wallet Support: Valora, WalletConnect v2

    Notes:
    - This contract does NOT create its own token.
    - cUSD is used for all payments.
    - CELO is used to pay gas fees and can be withdrawn by the owner.
    - Agents handle cash-in/cash-out for users.
*/

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CeloHT is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public cUSD; // Stable token for payments

    // =========================
    // Events
    // =========================
    event PaymentSent(address indexed from, address indexed to, uint256 amount, string reference);
    event AgentDeposit(address indexed agent, uint256 amount);
    event AgentWithdraw(address indexed agent, uint256 amount);
    event WithdrawCUSD(address indexed owner, uint256 amount);
    event WithdrawCELO(address indexed owner, uint256 amount);

    // =========================
    // Constructor
    // =========================
    constructor(address _cUSD) {
        require(_cUSD != address(0), "Invalid cUSD address");
        cUSD = IERC20(_cUSD);
    }

    // =========================
    // Core Payment Functions
    // =========================

    /// @notice Send cUSD payment from sender to recipient
    /// @param to Recipient address
    /// @param amount Amount of cUSD to send
    /// @param reference Optional reference string for the payment
    function sendPayment(
        address to,
        uint256 amount,
        string memory reference
    ) external nonReentrant returns (bool) {
        require(to != address(0), "Invalid recipient");
        require(amount > 0, "Invalid amount");

        // Transfer cUSD safely from sender to recipient
        cUSD.safeTransferFrom(msg.sender, to, amount);

        emit PaymentSent(msg.sender, to, amount, reference);
        return true;
    }

    // =========================
    // Agent Functions (Cash-in / Cash-out)
    // =========================

    /// @notice Agents deposit cUSD to the contract (Cash-in)
    /// @param amount Amount of cUSD to deposit
    function agentDeposit(uint256 amount) external nonReentrant returns (bool) {
        require(amount > 0, "Invalid amount");

        // Transfer cUSD from agent to contract
        cUSD.safeTransferFrom(msg.sender, address(this), amount);

        emit AgentDeposit(msg.sender, amount);
        return true;
    }

    /// @notice Agents withdraw cUSD from contract (Cash-out)
    /// @dev Only owner can approve agent withdrawals for security
    /// @param amount Amount of cUSD to withdraw
    function agentWithdraw(uint256 amount) external onlyOwner nonReentrant returns (bool) {
        require(amount > 0, "Invalid amount");
        require(cUSD.balanceOf(address(this)) >= amount, "Insufficient balance");

        // Transfer cUSD from contract to owner (agent withdrawal)
        cUSD.safeTransfer(owner(), amount);

        emit AgentWithdraw(msg.sender, amount);
        return true;
    }

    // =========================
    // Owner Withdraw Functions
    // =========================

    /// @notice Withdraw cUSD from contract to owner
    /// @param amount Amount of cUSD to withdraw
    function withdrawCUSD(uint256 amount) external onlyOwner nonReentrant returns (bool) {
        require(amount > 0, "Invalid amount");

        cUSD.safeTransfer(owner(), amount);
        emit WithdrawCUSD(owner(), amount);
        return true;
    }

    /// @notice Withdraw CELO (native token) from contract to owner
    /// @param amount Amount of CELO to withdraw
    function withdrawCELO(uint256 amount) external onlyOwner nonReentrant returns (bool) {
        require(amount > 0, "Invalid amount");
        require(address(this).balance >= amount, "Insufficient CELO balance");

        // Send CELO to owner
        (bool sent, ) = owner().call{value: amount}("");
        require(sent, "CELO withdraw failed");

        emit WithdrawCELO(owner(), amount);
        return true;
    }

    // =========================
    // Contract Balance Views
    // =========================

    /// @notice Returns the current cUSD balance of the contract
    function contractCUSDBalance() external view returns (uint256) {
        return cUSD.balanceOf(address(this));
    }

    /// @notice Returns the current CELO balance of the contract
    function contractCELOBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // =========================
    // Fallback / Receive for CELO
    // =========================

    /// @notice Allow contract to receive CELO directly
    receive() external payable {}

    /// @notice Fallback in case non-matching function call or CELO sent
    fallback() external payable {}
}