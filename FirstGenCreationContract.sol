pragma solidity >= 0.8;

import "./CreationInterface.sol";
import "./Kaiju.sol";
import "./KaijuContract.sol";


contract FirstGenCreation is KaijuCreation{
    ProjectKaiju private _kaijuContract;

    constructor(address kaijuContract){
        _kaijuContract = ProjectKaiju(kaijuContract);
    }

    function CreateKaiju(KaijuEgg memory eggVals) view external returns(Kaiju memory){
        Kaiju memory kaiju;
        Kaiju memory parent1 = _kaijuContract.getKaiju(eggVals.parent1);
        Kaiju memory parent2 = _kaijuContract.getKaiju(eggVals.parent2);

        kaiju.elementType = parent1.elementType;
        kaiju.attack = uint8((uint16(parent1.attack) + parent2.attack + uint8(bytes32(eggVals.randomNumber)[0])/3));
        kaiju.defense = uint8((uint16(parent1.defense) + parent2.defense + uint8(bytes32(eggVals.randomNumber)[1])/3));
        kaiju.speed = uint8((uint16(parent1.speed) + parent2.speed + uint8(bytes32(eggVals.randomNumber)[2])/3));
        kaiju.luck = uint8((uint16(parent1.luck) + parent2.luck + uint8(bytes32(eggVals.randomNumber)[3])/3));
        kaiju.health = uint8((uint16(parent1.health) + parent2.health + uint8(bytes32(eggVals.randomNumber)[4])/3));
        kaiju.shinyness = uint16(uint8(bytes32(eggVals.randomNumber)[5]))<<8 | uint8(bytes32(eggVals.randomNumber)[6]);
        kaiju.rarity = uint16(uint8(bytes32(eggVals.randomNumber)[7]))<<8 | uint8(bytes32(eggVals.randomNumber)[8]);

        return kaiju;
    }
}