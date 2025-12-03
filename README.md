README.md

CeloHT  Haiti’s Web3, Regeneration & Digital Inclusion Network

Official Logo

![Image](https://github.com/user-attachments/assets/8c59e434-db05-47e4-8e86-2d3d35d83af3)




 About CeloHT

CeloHT is a community-driven ecosystem designed to accelerate Haiti’s digital, economic, and environmental transformation through Web3 education, blockchain empowerment, climate regeneration, and financial inclusion.

We build tools, train communities, and create long-term, measurable impact.



 Mission

To build a financially inclusive, climate-resilient, and digitally empowered Haiti using Web3 technology and sustainable development models.

 Vision

A digitally advanced and environmentally restored Haiti where every citizen has access to tools for growth.

 Core Values

Transparency & Accountability

Open & Accessible Education

Innovation for Social Impact

Regeneration & Environmental Action

Community-Driven Development





 Governance Structure

Leadership Committee (7 Members)

Executive Director – Global strategy, partnerships

Operations Lead – Field coordination & logistics

Education Lead – Learning frameworks & training

Community Programs Lead – Agent supervision

Technology Lead – CELO tools, innovations, dApps

Climate & Environment Lead – Green initiatives

Compliance & Partnerships Lead – Reporting & governance





50 Volunteer Agents

Community Agents (CA) – Education, onboarding, support

Digital Agents (DA) – Wallets, Valora, Web3 tools

Environmental Agents (EA) – Recycling, reforestation, climate action




 Key Programs

Web3 Education Program

CeloHT Learning Camps

Valora Distribution Points

Digital Inclusion Workforce

Youth Empowerment

Green Project (Reforestation, Recycling)

Open-Source Tools





 Green Project — Environmental Program

Goals

Plant 200,000+ trees pa etap

Reduce waste in targeted communities

Teach climate awareness


Activities

Tree planting

Community recycling

Environmental workshops





 Valora Distribution Points

Services Offered

Wallet creation

Technical support

CELO/stablecoin onboarding

Financial literacy

Secure transaction training




 Roadmap 2025–2030

2025

Deploy agent network nationwide

Launch 10 Valora distribution centers

Start Green Initiative Phase I


2026

Expand to 15 communities

Create Web3 education toolkit

Start Recycling Centers


2027

Open Haiti Blockchain Accelerator


2028

Regional Digital Learning Hub


2029–2030

National digital inclusion mission

International partnerships

Full environmental regeneration program




 LICENSE (MIT)

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.




 CODE_OF_CONDUCT.md

# CeloHT Code of Conduct

## 1. Be Respectful
All contributors must treat others with dignity.

## 2. No Harassment
Harassment of any form is prohibited.

## 3. Professional Behavior
All actions must reflect integrity and transparency.

## 4. Zero Tolerance for Corruption
Any corruption, bribery, or unethical behavior results in permanent removal.

## 5. Reporting Issues
Email: celoht3@gmail.com



 CONTRIBUTING.md

# Contributing to CeloHT

## How to Contribute
1. Fork the repository
2. Create a feature branch
3. Submit a Pull Request

## Coding Standards
- Write clean and documented code
- Follow open-source best practices

## Documentation
All contributions must include documentation updates when required.




 SECURITY.md

# CeloHT Security Policy

## Reporting a Vulnerability
If you discover a security issue, contact:
Email: celoht3@gmail.com

## Supported Versions
All main branches are actively monitored.

## Responsible Disclosure
Do not publicly disclose vulnerabilities without coordination.




 /docs — Fully Filled

Whitepaper.pdf (text version here for GitHub)

# CeloHT Whitepaper

CeloHT is a Web3-driven initiative transforming Haiti through education,
digital inclusion, and environmental regeneration.

## Objectives
- Train 50,000+ citizens
- Deploy national Web3 programs
- Implement environmental cleanup systems
- Build a decentralized digital ecosystem

Mission-Vision.pdf (text version)

Mission: Create digital and climate resilience.
Vision: A regenerated, digitally empowered Haiti.

Green-Project-Overview.pdf (text version)

The Green Project focuses on reforestation, recycling, and climate education.

Valora-Distribution-Report.pdf (text version)

Valora Distribution Points: 10 initial locations, expanding to 30.
Services include onboarding, CELO education, support.




 /governance (Fully Filled)

Committee-Structure.md

Defines roles of the 7 committee members and workflow.

Roles-Responsibilities.md

Each role has documented responsibilities and deliverables.

Ethical-Standards.md

CeloHT forbids bribery, corruption, discrimination, and fraud.

Decision-Making-Policy.md

Major decisions require 4/7 committee majority.

Financial-Transparency.md

Quarterly financial reports published publicly.




 /brand (Fully Filled)

Colors.md

Primary: Dark Blue (#001F3F)
Secondary: Yellow (#FFCC00)

Typography.md

Font: Inter / Poppins
Weights: 400, 600, 700




 /green-project

Tree-Planting-Plan.md

Phase I: 20,000 trees
Phase II: 80,000 trees
Phase III: 100,000+ trees

Recycling-Model.md

Community sorting centers + school recycling education programs.

Climate-Workshops.md

Workshops on climate change, waste reduction, and environmental protection.




 /valora-distribution

Locations.json

[
  {"location": "leogane", "status": "active"},
  {"location": "Cap-Haïtien", "status": "active"}
]

Access-Point-Setup.md

Setup includes: smartphone, internet, Valora training materials.

Training-Manual.md

Step-by-step guide for onboarding new Valora users.




/reports

Q1-Activity-Report.pdf (text)

CeloHT trained 2,300+ citizens in Q1.

Q2-Activity-Report.pdf (text)

Expansion of agent network and environmental outreach.

Green-Initiative-Impact.pdf (text)

Community cleanup + 5,000 trees planted.

Valora-User-Growth.pdf (text)

Valora adoption increased by 38% in target regions.

// SPDX-License-Identifier: MIT pragma solidity ^0.8.20;

/**

@title CeloHTTreasury

@notice Multi-signature-like treasury contract intended for community-managed funds.

Designed with common audit-friendly patterns (OpenZeppelin libraries,

reentrancy guards, explicit events, and NatSpec comments).

Features:

Owners-based approval flow for outgoing transfers (ETH/native or ERC20)


Configurable required approvals threshold (>=1 and <= owners.length)


Ability for owner set to be updated by multisig (proposals)


Emergency pause controlled by single admin (deployer) to allow immediate mitigation


while the multisig coordinates a fix. (This is a pragmatic compromise — for

maximum decentralization you can replace single admin pause with a multisig pause)

Reentrancy protection and use of SafeERC20


NOTE (IMPORTANT):

This contract is a template for a well-documented, audit-ready contract. A full


external security audit is still required before mainnet/cUSD usage.

We recommend deploying on Alfajores (Celo testnet) and running automated tests and


fuzzing tools before any external audit. */


import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; import "@openzeppelin/contracts/access/Ownable.sol";

contract CeloHTTreasury is ReentrancyGuard, Ownable { using SafeERC20 for IERC20;

/* -------------------------------------------------------------------------- */
/*                                 STRUCTS                                     */
/* -------------------------------------------------------------------------- */

enum ProposalType { Transfer, AddOwner, RemoveOwner, ChangeThreshold }

struct Proposal {
    ProposalType pType;
    address token; // address(0) for native CELO/currency transfers
    address to;    // recipient (for transfer) or target owner (for owner changes)
    uint256 amount; // for transfer
    uint256 newThreshold; // for ChangeThreshold
    uint256 approvalsCount;
    bool executed;
    uint256 createdAt;
}

/* -------------------------------------------------------------------------- */
/*                                 STATE                                       */
/* -------------------------------------------------------------------------- */

mapping(uint256 => Proposal) public proposals;
mapping(uint256 => mapping(address => bool)) public hasApproved;
uint256 public proposalCount;

address[] public owners;
mapping(address => bool) public isOwner;
uint256 public requiredApprovals; // number of approvals required to execute

// Emergency pause controlled by owner (deployer or transferred owner)
bool public paused;

/* -------------------------------------------------------------------------- */
/*                                 EVENTS                                      */
/* -------------------------------------------------------------------------- */

event ProposalCreated(uint256 indexed id, ProposalType pType, address indexed proposer);
event Approved(uint256 indexed id, address indexed approver);
event Revoked(uint256 indexed id, address indexed revoker);
event Executed(uint256 indexed id, address indexed executor);
event OwnerAdded(address indexed newOwner);
event OwnerRemoved(address indexed removedOwner);
event RequiredApprovalsChanged(uint256 indexed newThreshold);
event Paused(address indexed admin);
event Unpaused(address indexed admin);
event Received(address indexed sender, uint256 amount);

/* -------------------------------------------------------------------------- */
/*                                MODIFIERS                                    */
/* -------------------------------------------------------------------------- */

modifier onlyOwnerOrSelf() {
    require(isOwner[msg.sender] || msg.sender == address(this), "Not owner");
    _;
}

modifier notPaused() {
    require(!paused, "Treasury is paused");
    _;
}

/* -------------------------------------------------------------------------- */
/*                              INITIALIZATION                                 */
/* -------------------------------------------------------------------------- */

/**
 * @notice Deploy with initial owners and required approvals.
 * @param _owners initial owner addresses
 * @param _requiredApprovals approvals required to execute a proposal
 */
constructor(address[] memory _owners, uint256 _requiredApprovals) {
    require(_owners.length > 0, "Owners required");
    require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, "Invalid approvals count");

    for (uint256 i = 0; i < _owners.length; i++) {
        address o = _owners[i];
        require(o != address(0), "Zero owner");
        require(!isOwner[o], "Duplicate owner");
        isOwner[o] = true;
        owners.push(o);
    }
    requiredApprovals = _requiredApprovals;
    // Set deployer as contract owner for emergency pause control
    transferOwnership(msg.sender);
}

receive() external payable {
    emit Received(msg.sender, msg.value);
}

/* -------------------------------------------------------------------------- */
/*                            OWNER / PAUSE FUNCTIONS                           */
/* -------------------------------------------------------------------------- */

/// @notice Emergency pause (single-admin). Use only for quick mitigation.
function pause() external onlyOwner {
    paused = true;
    emit Paused(msg.sender);
}

/// @notice Unpause contract
function unpause() external onlyOwner {
    paused = false;
    emit Unpaused(msg.sender);
}

/* -------------------------------------------------------------------------- */
/*                            PROPOSAL LIFECYCLE                              */
/* -------------------------------------------------------------------------- */

/**
 * @notice Create a transfer proposal (native or ERC20) or admin proposals.
 */
function createTransferProposal(address _token, address _to, uint256 _amount) external onlyOwnerOrSelf notPaused returns (uint256) {
    require(_to != address(0), "Zero recipient");
    require(_amount > 0, "Amount zero");

    uint256 id = proposalCount++;
    proposals[id] = Proposal({
        pType: ProposalType.Transfer,
        token: _token,
        to: _to,
        amount: _amount,
        newThreshold: 0,
        approvalsCount: 0,
        executed: false,
        createdAt: block.timestamp
    });

    emit ProposalCreated(id, ProposalType.Transfer, msg.sender);
    return id;
}

function createAddOwnerProposal(address _newOwner) external onlyOwnerOrSelf notPaused returns (uint256) {
    require(_newOwner != address(0), "Zero address");
    require(!isOwner[_newOwner], "Already owner");

    uint256 id = proposalCount++;
    proposals[id] = Proposal({
        pType: ProposalType.AddOwner,
        token: address(0),
        to: _newOwner,
        amount: 0,
        newThreshold: 0,
        approvalsCount: 0,
        executed: false,
        createdAt: block.timestamp
    });

    emit ProposalCreated(id, ProposalType.AddOwner, msg.sender);
    return id;
}

function createRemoveOwnerProposal(address _owner) external onlyOwnerOrSelf notPaused returns (uint256) {
    require(isOwner[_owner], "Not an owner");

    uint256 id = proposalCount++;
    proposals[id] = Proposal({
        pType: ProposalType.RemoveOwner,
        token: address(0),
        to: _owner,
        amount: 0,
        newThreshold: 0,
        approvalsCount: 0,
        executed: false,
        createdAt: block.timestamp
    });

    emit ProposalCreated(id, ProposalType.RemoveOwner, msg.sender);
    return id;
}

function createChangeThresholdProposal(uint256 _newThreshold) external onlyOwnerOrSelf notPaused returns (uint256) {
    require(_newThreshold > 0 && _newThreshold <= owners.length, "Invalid threshold");

    uint256 id = proposalCount++;
    proposals[id] = Proposal({
        pType: ProposalType.ChangeThreshold,
        token: address(0),
        to: address(0),
        amount: 0,
        newThreshold: _newThreshold,
        approvalsCount: 0,
        executed: false,
        createdAt: block.timestamp
    });

    emit ProposalCreated(id, ProposalType.ChangeThreshold, msg.sender);
    return id;
}

/**
 * @notice Approve a proposal. An owner can approve once per proposal.
 */
function approve(uint256 _id) external onlyOwnerOrSelf notPaused {
    Proposal storage p = proposals[_id];
    require(!p.executed, "Already executed");
    require(!hasApproved[_id][msg.sender], "Already approved");

    hasApproved[_id][msg.sender] = true;
    p.approvalsCount += 1;
    emit Approved(_id, msg.sender);
}

/**
 * @notice Revoke an approval before execution.
 */
function revoke(uint256 _id) external onlyOwnerOrSelf notPaused {
    Proposal storage p = proposals[_id];
    require(!p.executed, "Already executed");
    require(hasApproved[_id][msg.sender], "Not approved yet");

    hasApproved[_id][msg.sender] = false;
    p.approvalsCount -= 1;
    emit Revoked(_id, msg.sender);
}

/**
 * @notice Execute a proposal once it has enough approvals.
 */
function execute(uint256 _id) external nonReentrant onlyOwnerOrSelf notPaused {
    Proposal storage p = proposals[_id];
    require(!p.executed, "Already executed");
    require(p.approvalsCount >= requiredApprovals, "Not enough approvals");

    p.executed = true; // optimistic state change to prevent reentrancy issues

    if (p.pType == ProposalType.Transfer) {
        _executeTransfer(p.token, p.to, p.amount);
    } else if (p.pType == ProposalType.AddOwner) {
        _addOwner(p.to);
    } else if (p.pType == ProposalType.RemoveOwner) {
        _removeOwner(p.to);
    } else if (p.pType == ProposalType.ChangeThreshold) {
        _changeThreshold(p.newThreshold);
    }

    emit Executed(_id, msg.sender);
}

/* -------------------------------------------------------------------------- */
/*                                INTERNALS                                    */
/* -------------------------------------------------------------------------- */

function _executeTransfer(address _token, address _to, uint256 _amount) internal {
    if (_token == address(0)) {
        // native transfer
        (bool sent, ) = _to.call{value: _amount}('');
        require(sent, "Native transfer failed");
    } else {
        IERC20(_token).safeTransfer(_to, _amount);
    }
}

function _addOwner(address _newOwner) internal {
    require(_newOwner != address(0), "Zero address");
    require(!isOwner[_newOwner], "Already owner");
    isOwner[_newOwner] = true;
    owners.push(_newOwner);
    emit OwnerAdded(_newOwner);
}

function _removeOwner(address _owner) internal {
    require(isOwner[_owner], "Not an owner");
    // remove from mapping and array (preserve order by swapping with last)
    isOwner[_owner] = false;
    uint256 len = owners.length;
    for (uint256 i = 0; i < len; i++) {
        if (owners[i] == _owner) {
            owners[i] = owners[len - 1];
            owners.pop();
            break;
        }
    }
    // ensure requiredApprovals still valid
    if (requiredApprovals > owners.length) {
        requiredApprovals = owners.length;
        emit RequiredApprovalsChanged(requiredApprovals);
    }
    emit OwnerRemoved(_owner);
}

function _changeThreshold(uint256 _newThreshold) internal {
    require(_newThreshold > 0 && _newThreshold <= owners.length, "Invalid threshold");
    requiredApprovals = _newThreshold;
    emit RequiredApprovalsChanged(_newThreshold);
}

/* -------------------------------------------------------------------------- */
/*                                 VIEW HELPERS                                */
/* -------------------------------------------------------------------------- */

function getOwners() external view returns (address[] memory) {
    return owners;
}

function getProposal(uint256 _id) external view returns (Proposal memory) {
    return proposals[_id];
}

function getProposalsCount() external view returns (uint256) {
    return proposalCount;
}

/* -------------------------------------------------------------------------- */
/*                             ADMIN / RECOVERY NOTES                          */
/* -------------------------------------------------------------------------- */

// In case tokens are accidentally sent directly to this contract and not via proposals,
// owners can create a transfer proposal to withdraw.

// IMPORTANT: This contract is intentionally conservative (no arbitrary execute function
// for arbitrary calldata). If you need richer governance (timelock + governance calls)
// integrate with a proper Governance/Timelock contract.

}

/* -------------------------------------------------------------------------- / /                               README + AUDIT NOTES                          / / -------------------------------------------------------------------------- */

/* README (to add to GitHub alongside the contract)

CeloHT Treasury (Multisig-style) - Solidity

This repository contains a template smart contract CeloHTTreasury designed to manage community funds in a multisig-like fashion. The contract is intentionally simple, well-documented, and built using established OpenZeppelin patterns for auditability.

Files

contracts/CeloHTTreasury.sol - Main contract


Key security features

Uses OpenZeppelin SafeERC20 and ReentrancyGuard.

Explicit approval workflow for all outgoing transfers and admin changes.

Events for all important state changes and actions.

Emergency pause controlled by the deployer/admin to mitigate active attacks.


Recommended deployment steps

1. Deploy to Alfajores (Celo testnet) and perform full integration tests.


2. Run unit tests (Hardhat/Foundry) and gas profiling.


3. Use static analysis tools (Slither) and fuzzing (Echidna / Foundry fuzz).


4. Order an external audit from a reputable firm and publish the report.


5. After audit fixes, deploy to mainnet and use a verified multisig wallet (Gnosis Safe) pattern for treasury management (this contract can be the treasury behind Gnosis too).



Suggested test checklist

Test transfer proposals for native and ERC20 tokens.

Test owner add/remove flows and threshold changes.

Test approval/revoke race conditions.

Test reentrancy attempt vectors.

Validate edge cases: removing last owner, threshold > owners, duplicate owners.


Audit checklist (short):

Verify all arithmetic and edge cases.

Confirm there are no front-running or reentrancy attack vectors.

Verify mapping & approvals cannot be spoofed.

Confirm safe handling of native transfers and gas stipend assumptions.

Check for storage layout / upgradeability concerns (if planning proxies).

Verify correct usage of SafeERC20 and appropriate return data handling.


IMPORTANT: This template needs a full third-party audit and should be deployed to testnets only until audits and thorough testing are complete. */
 

📬 Contact

Email: celoht3@gmail.com Organization: CeloHT Mission: Digital + Environmental + Financial Empowerment

