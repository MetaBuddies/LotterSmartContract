const Migrations = artifacts.require("Lotter");

module.exports = function (deployer) {
  deployer.deploy(Migrations,"test","test");
};
