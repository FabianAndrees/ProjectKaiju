pragma solidity >= 0.8;

import "./CreationInterface.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./KaijuScales.sol";
import "./CrystalMango.sol";
import "./KaijuContract.sol";
import "./BreedingCostCalculator.sol";
import "./RandomNumberProvider.sol";
import "./KaijuEggContract.sol";

struct callbackEntry{
    address issuer;
    uint256 kaiju1; 
    uint256 kaiju2;
}

contract KaijuBreeding is Ownable, Pausable{
    event InitBreed(address issuer, uint256 kaiju1, uint256 kaiju2, uint256 callbackId);
    event FinishedBreed(address issuer, uint256 kaiju1, uint256 kaiju2, uint256 callbackId);
    KaijuScales private _scales;
    CrystalMango private _mango;
    ProjectKaiju private _kaijuContract;
    KaijuEggContract private _eggContract;
    BreedingCostCalculator private _costCalculator;
    RandomNumberProvider private _provider;

    constructor(address egg){
        _eggContract = KaijuEggContract(egg);
        _kaijuContract = ProjectKaiju(_eggContract.getKaijuContract()); 
    }

    mapping(uint256 => callbackEntry) public callbackMap;

    function initBreed(uint256 kaiju1, uint256 kaiju2) external whenNotPaused{
        require(kaiju1 != kaiju2);
        require(_kaijuContract.ownerOf(kaiju1) == msg.sender, "You're trying to breed with a Kaiju you don't own");
        require(_kaijuContract.ownerOf(kaiju2) == msg.sender, "You're trying to breed with a Kaiju you don't own");
        _costCalculator.canBreed(msg.sender, kaiju1, kaiju2);
        (uint256 ks, uint256 cm) = _costCalculator.calculateBreedingCost(msg.sender, kaiju1, kaiju2);
        _scales.operatorBurn(msg.sender, ks, "burned for breeding", "");
        _mango.operatorBurn(msg.sender, cm, "burned for breeding", "");
        uint256 id = _provider.getRandomNumberCallback();
        callbackEntry storage entry = callbackMap[id];
        entry.kaiju1 = kaiju1;
        entry.kaiju2 = kaiju2;
        entry.issuer = msg.sender;
        emit InitBreed(msg.sender, kaiju1, kaiju2, id);
    }

    function finishBreed(uint256 callbackId, uint256 random) external {
        require(msg.sender == address(_provider));
        require(callbackMap[callbackId].issuer != address(0));
        callbackEntry memory entry = callbackMap[callbackId];
        delete callbackMap[callbackId];
        _eggContract.mint(entry.issuer, entry.kaiju1, entry.kaiju2, random);
        emit FinishedBreed(entry.issuer, entry.kaiju1, entry.kaiju2, callbackId);
    }

    function setKaijuScales(address scalesAddress) external onlyOwner{
        require(address(_scales) == address(0));
        _scales = KaijuScales(scalesAddress);
    }
    
    function setMango(address mangoAddress) external onlyOwner{
        require(address(_mango) == address(0));
        _mango = CrystalMango(mangoAddress);
    }

    function setRngProvider(address provider) external onlyOwner{
        _provider = RandomNumberProvider(provider);
    }

    function setBreedingCalc(address calcContract) external {
        _costCalculator = BreedingCostCalculator(calcContract);
    }

    function pause() external onlyOwner{
        _pause();
    }

    function unpause() external onlyOwner{
        _unpause();
    }
}