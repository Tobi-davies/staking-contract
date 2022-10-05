// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

contract Stake {
    address Simba;
    uint256 factor = 1e11;
    uint256 delta = 3854;
     address BAYC = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;

//     IERC721 boredApe;
// IERC20 Limba;
    uint ratePerMin = 231481481000;  //0.00000231481481 per min
    // uint rewardPercent;

    struct UserStake {
        address staker;
        uint256 stakedAmount;
        // uint claimTime;
        uint40 lastTimeStaked;
    }
    mapping(address => UserStake) private userdata;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint216 amount);
    event InterestPaid(address indexed user, uint216 amount);
    event InterestCompounded(address indexed user, uint216 amount);

    constructor(address _simba){
        Simba = _simba;

    }

    function stake(uint256 _amount) external  {
        assert(ERC20(Simba).transferFrom(msg.sender, address(this), _amount));
 UserStake storage user = userdata[msg.sender];
 assert(BAYU(BAYC).balanceOf(msg.sender) > 0);

 if(user.stakedAmount > 0){
     uint256 currentReward = getRewards(msg.sender);
 user.stakedAmount += currentReward;
  emit InterestCompounded(msg.sender, uint216(currentReward));
 }
 user.stakedAmount += _amount;
 user.lastTimeStaked = uint40(block.timestamp);

 emit Staked(msg.sender, _amount);
     }

    function unstake(uint _amount) external {
        UserStake storage user = userdata[msg.sender];
        assert(user.stakedAmount > _amount);
        uint216 amountOut;
        amountOut = uint216(_amount);
        amountOut+= getRewards(msg.sender);
        // uint256 currentReward = getRewards();
        ERC20(Simba).transfer(msg.sender, amountOut);

        //update Storage
        user.stakedAmount-=_amount;

emit Withdrawn(msg.sender, amountOut);

    }

    function getRewards (address _user) internal  returns(uint216 reward) {
        UserStake memory user = userdata[_user];
        if(user.stakedAmount > 0){
  uint216 currentBal = uint216(user.stakedAmount);
uint40 lastTime = user.lastTimeStaked;
uint40 duration =uint40( block.timestamp) - lastTime;
 uint256 minPassed = duration / 60;
     uint256 minGen = ratePerMin * minPassed;
         reward = uint216((minGen * currentBal) / 1e17);

         emit InterestCompounded(_user, reward);
        }
          
    }

    function getUser(address _user) public view returns(UserStake memory user) {
       user = userdata[_user];
    }
}

interface BAYU {
    function balanceOf(address owner) external view returns (uint256);
}

// has bored ape: 0xDCf28bC785AE4Ba5eBfe4e1FAB9D505677AADBE1
// has bored ape: 0x758c32B770d656248BA3cC222951cF1aC1DdDAaA
// BAYC: 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D