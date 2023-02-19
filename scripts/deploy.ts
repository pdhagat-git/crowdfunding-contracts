import { ethers, upgrades } from "hardhat";

async function main() {
	const SampleToken = await ethers.getContractFactory("SampleToken");
	console.log("Deploying SampleToken...");
	const tokenContract = await upgrades.deployProxy(SampleToken, {
		initializer: "initialize",
	});

	await tokenContract.deployed();
	console.log("SampleToken Contract deployed to:", tokenContract.address);

	const Crowdfund = await ethers.getContractFactory("Crowdfund");
	const crowdfundTarget = "2000000000000000000"; // 2 * 10 ** 18

	console.log("Deploying Crowdfund...");
	const crowdfundContract = await upgrades.deployProxy(
		Crowdfund,
		[tokenContract.address, crowdfundTarget],
		{
			initializer: "initialize",
		},
	);

	await crowdfundContract.deployed();
	console.log("Crowdfund Contract deployed to:", crowdfundContract.address);
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
