// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; 

import "hardhat/console.sol";
import "./NFTContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 

contract StakingContract is Ownable {

    // ERC721
    NFTContract public nftContract;

    // ERC20
    IERC20 public daiContract;

    mapping(address => uint256) public balances;

    uint256 public priceOfFullVideo;

    // Events
    event PlayerToStake(address player, uint256 priceInput);
    event PlayerToUnstate(address player, uint256 priceOutput);

    constructor(address _nftContractAddress, address _daiContractAddress) {
        nftContract = NFTContract(_nftContractAddress);
        daiContract = IERC20(_daiContractAddress); // Initialize the USDC contract

    }

    // Player should staking some eth
    function stake(uint256 tokenId, uint256 amount) public returns(bool stakeSate){
        priceOfFullVideo = nftContract.getpriceOfFullVideo(tokenId);
        require(amount == priceOfFullVideo, "Must send exact amount");

        daiContract.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        emit PlayerToStake(msg.sender, amount);
        stakeSate = true;
        return stakeSate;
    }

    function unstake(uint256 priceOfAmountVideoWatched) public returns(bool unstakeState){
		uint256 amountOfVideoLeft =  priceOfFullVideo - priceOfAmountVideoWatched;
        require(balances[msg.sender] >= amountOfVideoLeft, "You does not have enough tokens");

        balances[msg.sender] -= amountOfVideoLeft;
        daiContract.transfer(msg.sender, amountOfVideoLeft);
        emit PlayerToUnstate(msg.sender, amountOfVideoLeft);
        unstakeState = true;
        return unstakeState;
    }

    function ownerWithdrawAll() public payable onlyOwner {
        uint256 balance = daiContract.balanceOf(address(this));
        daiContract.transfer(msg.sender, balance);
}


	function getBalance() public view returns (uint256) {
    	return balances[msg.sender];
    }


}

