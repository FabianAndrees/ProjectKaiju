pragma solidity >= 0.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Kaiju.sol";
import "./CreationInterface.sol";

contract ProjectKaiju is ERC721, Ownable{
    KaijuCreation private _creation;
    address private _kaijuEggAddress;
    Kaiju[] private _kaijus;

    constructor(address eggContract) ERC721("Kaiju", "Kaiju"){
        _kaijuEggAddress = eggContract;
    }

    function mint(address receiver, uint256 index, KaijuEgg memory eggValues) external {
        require(_kaijuEggAddress == msg.sender);
        require(address(_creation) == address(0), "CreationContract is not set!");
        _safeMint(receiver, index);
        _kaijus[index] = _creation.CreateKaiju(eggValues);
    }
    
    function getKaiju(uint256 id) view external returns(Kaiju memory) {
        return _kaijus[id];
    }

    function setCreationContract(address newContract) external onlyOwner {
        _creation = KaijuCreation(newContract);
    }
}