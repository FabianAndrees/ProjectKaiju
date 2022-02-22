pragma solidity >= 0.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./KaijuContract.sol";
import "./Kaiju.sol";
import "./KaijuBreeding.sol";
import "./KaijuICO.sol";

contract KaijuEggContract is ERC721Enumerable, Ownable{
    ProjectKaiju private _kaijuContract;
    KaijuBreeding private _kaijuBreeding;
    KaijuICO public _ico;

    mapping(uint256 => KaijuEgg) private eggs;
    uint256 currentId = 1;
    uint256 public hatchingTime;
    uint256 public icoCapacity;
    uint256 private lastMintBlock;

    constructor(uint256 icoCap, address erc20Token, uint256 costPerUnit) ERC721("Kaiju Egg", "K-Egg"){
        _kaijuContract = new ProjectKaiju(address(this));
        _ico = new KaijuICO(icoCap, erc20Token, costPerUnit, address(this));
        icoCapacity = icoCap;
    }

    function mint(address owner, uint256 kaiju1, uint256 kaiju2, uint256 random) external {
        require(address(_kaijuBreeding) == msg.sender);
        _safeMint(owner, currentId);
        eggs[currentId++] = KaijuEgg(random, block.timestamp, kaiju1, kaiju2);
    }
    
    function mintIco(uint8 amount) external {
        require(address(_ico) == msg.sender);
        require(lastMintBlock + amount <= block.number);
        lastMintBlock = block.number;
        for (uint256 index = 0; index < amount; index++) {
            require(icoCapacity-- > 0, "No ICO Capacity left");
            _safeMint(address(_ico), currentId);
            eggs[currentId++] = KaijuEgg(uint256(blockhash(block.number-index)), block.timestamp, 0, 0);
        }
    }

    function hatch(uint256 eggId) external {
        require(address(_kaijuContract) != address(0), "Kaiju Contract is not set");
        require(msg.sender == this.ownerOf(eggId));

        _burn(eggId);
        _kaijuContract.mint(msg.sender, eggId, eggs[eggId]);
    }

    function getKaijuContract() view external returns(address){
        return address(_kaijuContract);
    }

    function setKaijuBreeding(address breedingContract) external onlyOwner{
        _kaijuBreeding = KaijuBreeding(breedingContract);
    }
}