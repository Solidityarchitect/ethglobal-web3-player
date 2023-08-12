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
    IERC20 public usdcContract ;

    mapping(address => uint256) public balances;
    uint256 public priceOfFullVideo;

    // Events
    event PlayerToStake(address player, uint256 priceInput);
    event PlayerToUnstate(address player, uint256 priceOutput);

    constructor(address _nftContractAddress, address _usdcContractAddress) {
        nftContract = NFTContract(_nftContractAddress);
        usdcContract = IERC20(_usdcContractAddress); // Initialize the DAI contract

    }

    // Approve
    function approve(uint256 _amount) public {
        usdcContract.approve(address(this), _amount);
}


    // Player should staking some DAI
    function stake(uint256 tokenId) public returns(bool stakeSate){
        priceOfFullVideo = nftContract.getpriceOfFullVideo(tokenId);
        uint256 amount = priceOfFullVideo * 1e6;
        usdcContract.transferFrom(msg.sender, address(this), amount);
        emit PlayerToStake(msg.sender, amount);
        stakeSate = true;
        return stakeSate;
    }



    function unstake(uint256 priceOfAmountVideoWatched) public returns(bool unstakeState){
		uint256 amountOfVideoLeft =  priceOfFullVideo - priceOfAmountVideoWatched;
        require(usdcContract.balanceOf(msg.sender) >= amountOfVideoLeft, "You does not have enough tokens");

        usdcContract.transfer(msg.sender, amountOfVideoLeft);
        emit PlayerToUnstate(msg.sender, amountOfVideoLeft);
        unstakeState = true;
        return unstakeState;
    }

    function ownerWithdrawAll() public payable onlyOwner {
        uint256 balance = usdcContract.balanceOf(address(this)); 
        usdcContract.transfer(msg.sender, balance); 
}

	function getBalance() public view returns (uint256) {
    	return usdcContract.balanceOf(msg.sender);
    }
}

