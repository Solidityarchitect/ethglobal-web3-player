const { network, ethers } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    nftContract = await deployments.get("NFTContract")
    const usdcContractAddress = "0x07865c6E87B9F70255377e024ace6630C1Eaa37F"

    log("----------------------------------------------------")
    const arguments = [nftContract.address, usdcContractAddress]
    const stakingcontract = await deploy("StakingContract", {
        from: deployer,
        args: arguments,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    // Verify the deployment
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        log("Verifying...")
        await verify(stakingcontract.address, arguments)
    }
}

module.exports.tags = ["all", "stakingcontract", "main"]
