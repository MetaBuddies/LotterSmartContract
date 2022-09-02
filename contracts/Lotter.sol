// File: contracts/Lottery.sol
import "./ERC721Enumerable.sol";
import "./Ownable.sol";
/*
.____           __    __
|    |    _____/  |__/  |_  ___________
|    |   /  _ \   __\   __\/ __ \_  __ \
|    |__(  <_> )  |  |  | \  ___/|  | \/
|_______ \____/|__|  |__|  \___  >__|
\/                     \/
*/
pragma solidity >=0.7.0 <0.9.0;
/**
 * @title Lotter
 * @author jiremy
 */
contract Lotter is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string baseURI;
    string public baseExtension = ".json";
    uint256 public cost = 90000000000000;
    uint256 public maxSupply = 1098;
    uint256 public maxMintAmount = 4;
    uint256 public reservedForTeam = 10;
    string private signature;
    bool public paused = false;
    bool public revealed = false;
    uint256 public whitelistMintAmount = 3;
    uint256 public whitelistReserved = 1000;
    uint256 public whitelistCost = 90000000000000;
    bool private whitelistedSale = true;
    string public notRevealedUri;

    string _name = "Lotter";
    string _symbol = "LotterNft";
    /**
     * @notice Generate your blind box from here.
     * @return Return your token ID after the pre-sale ends.
     */
    constructor(string memory _initBaseURI,string memory _initNotRevealedUri) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
        setNotRevealedURI(_initNotRevealedUri);
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
    /***********************************|
    |               Presale             |
    |__________________________________*/

    /**
     * @notice The pre-sale method is used to mint for whitelisted users.
     * He is limited to whitelisted users.
     * @param _mintAmount The total amount of one mint.
     * @param _signature Signature for whitelisted users.
     * @return randomly generated TokenId
     */
    function presaleMint(uint256 _mintAmount, string memory _signature) public payable {
        require(!paused, "Contract is paused");
        require(whitelistedSale);
        require(keccak256(abi.encodePacked((signature))) == keccak256(abi.encodePacked((_signature))), "Invalid signature");
        require(msg.sender != owner());
        uint256 supply = totalSupply();
        uint256 totalAmount;
        uint256 tokenCount = balanceOf(msg.sender);
        require(tokenCount + _mintAmount <= maxMintAmount, string(abi.encodePacked("Limit token ", tokenCount.toString())));
        require(supply + _mintAmount <= maxSupply - reservedForTeam,"Max Supply");

        // Whitelist
        require(whitelistReserved - _mintAmount >= 0);
        require(tokenCount + _mintAmount <= whitelistMintAmount, "Maximum per wallet is 3 during whitelist");
        totalAmount = whitelistCost * _mintAmount;

        require(msg.value >= totalAmount,string(abi.encodePacked("Incorrect amount ",totalAmount.toString()," ",msg.value.toString())));
        whitelistReserved -= _mintAmount;
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    /***********************************|
    |               Public-sale         |
    |__________________________________*/

    /**
     * @notice The mint method is used to mint for public users.
     * Anyone can participate
     * @param _mintAmount The total amount of one mint.
     * @return randomly generated TokenId
     */
    function mint(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        uint256 totalAmount;
        require(!paused);
        require(_mintAmount > 0);
        // Owner
        if (msg.sender == owner()) {
            require(reservedForTeam >= _mintAmount);
            reservedForTeam -= _mintAmount;
        }
        if (msg.sender != owner()) {
            require(!whitelistedSale);
            uint256 tokenCount = balanceOf(msg.sender);
            require(tokenCount + _mintAmount <= maxMintAmount,string(abi.encodePacked("Limit token ", tokenCount.toString())));
            require(supply + _mintAmount <= maxSupply - reservedForTeam,"Max Supply");
            totalAmount = cost * _mintAmount;
            require(msg.value >= totalAmount,string(abi.encodePacked("Incorrect amount ",totalAmount.toString()," ",msg.value.toString())));
        }
        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }
    function walletOfOwner(address _owner)public view returns (uint256[] memory){
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId)public view virtual override returns (string memory){
        require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
        if (revealed == false) {
            return notRevealedUri;
        }
        string memory currentBaseURI = _baseURI();
        return
        bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI,tokenId.toString(),baseExtension)) : "";
    }

    //only owner
    function reveal() public onlyOwner {
        revealed = true;
    }

    function setReserved(uint256 _reserved) public onlyOwner {
        reservedForTeam = _reserved;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setWhitelistCost(uint256 _newCost) public onlyOwner {
        whitelistCost = _newCost;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)public onlyOwner{
        baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function whitelistSale(bool _state) public onlyOwner {
        require(whitelistReserved > 0);
        whitelistedSale = _state;
    }

    function setSignature(string memory _signature) public onlyOwner {
        signature = _signature;
    }

    function setWhitelistReserved(uint256 _count) public onlyOwner {
        uint256 totalSupply = totalSupply();
        require(_count < maxSupply - totalSupply);
        whitelistReserved = _count;
    }
    /**
     * @notice Here is how the project party withdraws funds
     * He only allows the contract owner to operate
     * @param No have param
     */
    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }
    /**
     * @notice Determine if it is during a whitelist sale
     * The return parameter is a boolean value
     * @param No have param
     */
    function isWhitelisted() public view returns (bool) {
        return whitelistedSale;
    }
}
