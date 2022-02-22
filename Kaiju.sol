pragma solidity >= 0.8;

struct Kaiju{
    uint256 experience;
    uint16 kaijuId;
    uint8 elementType;
    uint8 attack;
    uint8 defense;
    uint8 speed;
    uint8 luck;
    uint8 health;
    uint8 breedingCount;
    uint16 shinyness;
    uint16 rarity;
}

struct KaijuEgg{
    uint256 randomNumber;
    uint256 createdAt; 
    uint256 parent1;
    uint256 parent2;
}