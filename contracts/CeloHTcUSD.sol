// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CeloHT cUSD Smart Contract
 * @dev Professional smart contract for CeloHT on Celo blockchain
 *      Implements three main pillars: Education, Transfer Agent, Reforestation
 *      Includes ReentrancyGuard and transaction/donation limits for security
 */

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract CeloHTcUSD {

    address public owner;
    IERC20 public cUSD;

    uint256 public totalEducation;
    uint256 public totalReforestation;

    uint256 public constant MAX_DONATION = 10000 * 1e18; // Max donation per transaction
    uint256 public constant MAX_TRANSFER = 50000 * 1e18; // Max transfer per transaction

    struct User {
        uint256 totalSent;
        uint256 totalReceived;
    }

    mapping(address => User) public users;

    // Events for transparency
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Donation(address indexed from, string category, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Reentrancy guard
    bool private locked;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier noReentrancy() {
        require(!locked, "Reentrancy detected");
        locked = true;
        _;
        locked = false;
    }

    constructor(address _cUSD) {
        require(_cUSD != address(0), "Invalid cUSD address");
        owner = msg.sender;
        cUSD = IERC20(_cUSD);
    }

    /**
     * @dev Transfer cUSD between users
     */
    function transferFunds(address _to, uint256 _amount) external noReentrancy {
        require(_to != address(0), "Invalid address");
        require(_amount > 0 && _amount <= MAX_TRANSFER, "Amount invalid or exceeds limit");
        require(cUSD.balanceOf(msg.sender) >= _amount, "Insufficient balance");

        bool sent = cUSD.transferFrom(msg.sender, _to, _amount);
        require(sent, "Transfer failed");

        users[msg.sender].totalSent += _amount;
        users[_to].totalReceived += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    /**
     * @dev Donate cUSD to Education or Reforestation
     */
    function donate(uint256 _amount, string calldata _category) external noReentrancy {
        require(_amount > 0 && _amount <= MAX_DONATION, "Amount invalid or exceeds limit");
        require(cUSD.balanceOf(msg.sender) >= _amount, "Insufficient balance");

        bool sent = cUSD.transferFrom(msg.sender, address(this), _amount);
        require(sent, "Transfer failed");

        if (compareStrings(_category, "education")) {
            totalEducation += _amount;
            emit Donation(msg.sender, "education", _amount);
        } else if (compareStrings(_category, "reforestation")) {
            totalReforestation += _amount;
            emit Donation(msg.sender, "reforestation", _amount);
        } else {
            revert("Category must be 'education' or 'reforestation'");
        }
    }

    /**
     * @dev Withdraw cUSD (owner only)
     */
    function withdraw(uint256 _amount) external onlyOwner noReentrancy {
        require(cUSD.balanceOf(address(this)) >= _amount, "Insufficient contract balance");
        bool sent = cUSD.transfer(owner, _amount);
        require(sent, "Withdraw failed");
    }

    /**
     * @dev Transfer ownership
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Utility function to compare strings
     */
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    /**
     * @dev Get global stats
     */
    function getStats() external view returns (uint256 education, uint256 reforestation) {
        return (totalEducation, totalReforestation);
    }

    /**
     * @dev Get user stats
     */
    function getUserStats(address _user) external view returns (uint256 totalSent, uint256 totalReceived) {
        User memory u = users[_user];
        return (u.totalSent, u.totalReceived);
    }
}