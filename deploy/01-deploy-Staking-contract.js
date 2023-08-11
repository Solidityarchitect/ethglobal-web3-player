const { network, ethers } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    nftContract = await deployments.get("NFTContract")
    const daiContractAddress = "0x68194a729C2450ad26072b3D33ADaCbcef39D574"

    log("----------------------------------------------------")
    const arguments = [nftContract.address, daiContractAddress]
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
