pragma solidity ^0.4.18;

import {Ownable} from "./traits/Ownable.sol";
import "./math/SafeMath.sol";
import {Campaign} from "./Campaign.sol";
import "./Share.sol";
import {Vesting} from "./Vesting.sol";

import "../lib/ethereum-datetime/contracts/DateTime.sol";

contract VyralSale is Ownable {
    using SafeMath for uint;

    uint public constant MIN_CONTRIBUTION = 1 ether;

    enum Phase {
        Deployed,       //0
        Initialized,    //1
        Presale,        //2
        Freeze,         //3
        Ready,          //4
        Crowdsale,      //5
        Finalized,      //6
        Decomissioned   //7
    }

    Phase public phase;

    /** PRESALE PARAMS */
    uint public presaleStartTimestamp;
    uint public presaleEndTimestamp;
    uint public presaleRate;
    uint public presaleCap;

    bool public presaleCapReached;
    uint public soldPresale;

    /** CROWDSALE PARAMS */
    uint public saleStartTimestamp;
    uint public saleEndTimestamp;
    uint public saleRate;
    uint public saleCap;

    bool public saleCapReached;
    uint public soldSale;

    /** GLOBAL PARAMS */
    address public wallet;
    address public vestingWallet;
    Share public shareToken;
    Campaign public campaign;
    DateTime public dateTime;

    bool public vestingRegistered;

    uint public constant TOTAL_SUPPLY = 777777777 * (10 ** uint(18));

    uint public constant TEAM = TOTAL_SUPPLY.div(7);
    uint public constant PARTNERS = TOTAL_SUPPLY.div(7);
    uint public constant VYRAL_REWARDS = TOTAL_SUPPLY.div(7).mul(2);
    uint public constant SALE_ALLOCATION = TOTAL_SUPPLY.div(7).mul(3);

    /** MODIFIERS */
    modifier inPhase(Phase _phase) {
        require(phase == _phase);
        _;
    }

    modifier canBuy(Phase _phase) {
        require(phase == Phase.Presale || phase == Phase.Crowdsale);

        if (_phase == Phase.Presale) {
            require(block.timestamp >= presaleStartTimestamp);
        }
        if (_phase == Phase.Crowdsale) {
            require(block.timestamp >= saleStartTimestamp);
        }
        _;
    }

    modifier presaleOpenHours {
        uint8 hourUTC = dateTime.getHour(block.timestamp);
        require(hourUTC < 5 || hourUTC >= 16);
        _;
    }

    /** PHASES */

    function VyralSale() {
        phase = Phase.Deployed;

        shareToken = new Share();
        dateTime = new DateTime();
        // vestingWallet = new Vesting(address(shareToken));
    }

    function initialize(address _wallet,
                        uint _presaleStartTimestamp,
                        uint _presaleEndTimestamp,
                        uint _presaleCap,
                        uint _presaleRate)
        inPhase(Phase.Deployed)
        onlyOwner
        external returns (bool)
    {
        require(_wallet != 0x0);
        require(_presaleStartTimestamp > block.timestamp);
        require(_presaleEndTimestamp > _presaleStartTimestamp);
        require(_presaleCap < SALE_ALLOCATION.div(_presaleRate));

        wallet = _wallet;
        presaleStartTimestamp = _presaleStartTimestamp;
        presaleEndTimestamp = _presaleEndTimestamp;
        presaleCap = _presaleCap;

        // campaign = new Campaign(address(shareToken), VYRAL_REWARDS);

        // shareToken.approve(vestingWallet, TEAM.add(PARTNERS));
        // shareToken.addTransferrer(vestingWallet);
        // shareToken.addTransferrer(campaign);

        phase = Phase.Initialized;
        return true;
    }

    /// Step 1.5 - Register Vesting Schedules

    function startPresale()
        inPhase(Phase.Initialized)
        onlyOwner
        external returns (bool)
    {

        phase = Phase.Presale;
        return true;
    }

    function endPresale()
        inPhase(Phase.Presale)
        onlyOwner
        external returns (bool)
    {
        phase = Phase.Freeze;

        return true;
    }

    function readySale(uint _saleStartTimestamp,
                       uint _saleEndTimestamp,
                       uint _saleRate)
        inPhase(Phase.Freeze)
        onlyOwner
        external returns (bool)
    {
        require(_saleStartTimestamp > block.timestamp);
        require(_saleEndTimestamp > _saleStartTimestamp);

        saleStartTimestamp = _saleStartTimestamp;
        saleEndTimestamp = _saleEndTimestamp;
        saleCap = (SALE_ALLOCATION.div(_saleRate)).sub(presaleCap);

        phase = Phase.Ready;
        return true;
    }

    function startSale()
        inPhase(Phase.Ready)
        onlyOwner
        external returns (bool)
    {
        phase = Phase.Crowdsale;
        return true;
    }

    function finalizeSale()
        inPhase(Phase.Crowdsale)
        onlyOwner
        external returns (bool)
    {
        phase = Phase.Finalized;
        return true;
    }

    function decomission()
        inPhase(Phase.Finalized)
        onlyOwner
        external returns (bool)
    {
        phase = Phase.Decomissioned;
        return true;
    }

    /** BUY TOKENS */

    function ()
        public payable
    {
        if (phase == Phase.Presale) {
            buyPresale(0x0);
        }
        if (phase == Phase.Crowdsale) {
            buySale(0x0);
        }
        //else
        revert();
    }

    function buyPresale(address _referrer)
        inPhase(Phase.Presale)
        canBuy(Phase.Presale)
        presaleOpenHours
        public payable
    {
        require(msg.value >= MIN_CONTRIBUTION);
        require(!presaleCapReached);

        uint contribution = msg.value;

        uint purchased = contribution.mul(presaleRate);

        uint totalSold = soldPresale.add(contribution);
        uint excess; // extra ether sent
        if (totalSold >= presaleCap) {
            excess = totalSold.sub(presaleCap);
            if (excess > 0) {
                purchased = purchased.sub(excess.mul(presaleRate));
                contribution = contribution.sub(excess);
                msg.sender.transfer(excess);
            }
            presaleCapReached = true;
        }

        soldPresale = totalSold;
        wallet.transfer(contribution);
        shareToken.transfer(msg.sender, purchased);

        ///Calculate presale bonus
        uint reward = presaleBonusApplicator(contribution);
        shareToken.transferReward(msg.sender, reward);

        if (_referrer != address(0x0)) {
            campaign.join(_referrer, msg.sender, purchased);
        }
    }

    function presaleBonusApplicator(uint _contribution)
        internal view returns (uint reward)
    {
        if (block.timestamp <= presaleStartTimestamp.add(1 hours)) {
            return applyPercentage(_contribution, 70);
        }
        if (block.timestamp <= presaleStartTimestamp.add(1 days)) {
            return applyPercentage(_contribution, 50);
        }
        if (block.timestamp <= presaleStartTimestamp.add(2 days)) {
            return applyPercentage(_contribution, 45);
        }
        if (block.timestamp <= presaleStartTimestamp.add(20 days)) {
            uint numDays = (block.timestamp.sub(presaleStartTimestamp))
                                        .div(1 days);
            numDays = numDays.sub(2);
            return applyPercentage(_contribution, (45 - numDays));
        }
        if (block.timestamp <= presaleStartTimestamp.add(21 days)) {
            return applyPercentage(_contribution, 25);
        }
        if (block.timestamp <= presaleStartTimestamp.add(22 days)) {
            return applyPercentage(_contribution, 20);
        }
        if (block.timestamp <= presaleStartTimestamp.add(23 days)) {
            return applyPercentage(_contribution, 15);
        }
        //else
        revert();
    }

    function applyPercentage(uint _base, uint _percentage)
        internal pure returns (uint num)
    {
        num = _base.mul(_percentage).div(100);
    }

    function buySale(address _referrer)
        inPhase(Phase.Crowdsale)
        canBuy(Phase.Crowdsale)
        public payable
    {
        require(msg.value >= MIN_CONTRIBUTION);
        require(!saleCapReached);

        uint contribution = msg.value;

        uint purchased = contribution.mul(saleRate);

        uint totalSold = soldSale.add(contribution);
        uint excess; // extra ether sent
        if (totalSold >= saleCap) {
            excess = totalSold.sub(saleCap);
            if (excess > 0) {
                purchased = purchased.sub(excess.mul(saleRate));
                contribution = contribution.sub(excess);
                msg.sender.transfer(excess);
            }
            saleCapReached = true;
        }

        soldSale = totalSold;
        wallet.transfer(contribution);
        shareToken.transfer(msg.sender, purchased);

        if (_referrer != address(0x0)) {
            campaign.join(_referrer, msg.sender, purchased);
        }
    }

    /** ADMIN SETTERS */

    /// TODO

    /** EMERGENCY SWITCH */
    bool public HALT;

    function toggleHALT(bool _on)
        onlyOwner
        external returns (bool)
    {
        HALT = _on;
        return HALT;
    }

    /** LOGS */
    event PhaseShift(Phase phase);
    event Contribution(Phase phase, address buyer, uint contribution);
    event Referral(address referrer, address referree, uint reward);
}