let Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
    deployer.deploy(Migrations, {gas: 4500073});
};
