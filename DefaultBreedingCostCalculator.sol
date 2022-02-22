pragma solidity >= 0.8;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./BreedingCostCalculator.sol";
import "./KaijuContract.sol";
import "./Kaiju.sol";

contract DefaultBreedingCostCalculator is BreedingCostCalculator, Ownable{
    ProjectKaiju private _kaijuContract;
    uint256 public ksAmountPerBreeding = 300;
    uint256 public cmAmountPerBreeding = 300;
    
    constructor(address kaijuContractAddress){
        _kaijuContract = ProjectKaiju(kaijuContractAddress);
    }

    function calculateBreedingCost(address issuer, uint256 kaiju1, uint256 kaiju2) view external returns(uint256 ks, uint256 cm){
        ks = ksAmountPerBreeding;
        cm = cmAmountPerBreeding;

        uint256 factor = _kaijuContract.getKaiju(kaiju1).breedingCount + 1 * _kaijuContract.getKaiju(kaiju2).breedingCount + 1;
        
        return (ks * factor * 10 ** 18, cm * factor * 10 ** 18);
    }

    function canBreed(address issuer, uint256 kaiju1, uint256 kaiju2) view external {
        Kaiju memory k1 = _kaijuContract.getKaiju(kaiju1);
        Kaiju memory k2 = _kaijuContract.getKaiju(kaiju2);
        require(k1.breedingCount < 3, "Kaiju already has the maximum amount of breeds");
        require(k2.breedingCount < 3, "Kaiju already has the maximum amount of breeds");
        require(k1.kaijuId == k2.kaijuId);
    }

    function setKsAmount(uint256 newAmount) external onlyOwner{
        ksAmountPerBreeding = newAmount;
    }

    function setCmAmount(uint256 newAmount) external onlyOwner{
        cmAmountPerBreeding = newAmount;
    }
}