pragma solidity >= 0.8;

import "./KaijuContract.sol";
import "./CrystalMango.sol";
import "./BreedingCostCalculator.sol";
import "./ChainlinkConsumer.sol";
import "./CreationInterface.sol";
import "./DefaultBreedingCostCalculator.sol";
import "./FirstGenCreationContract.sol";
import "./Kaiju.sol";
import "./KaijuEggContract.sol";
import "./KaijuBreeding.sol";
import "./KaijuScales.sol";

contract KaijuDeployment{
    
    /**
     * Network: BSC Testnet
     * Chainlink VRF Coordinator address: 0xa555fC018435bef5A13C6c6870a9d4C11DEC329C
     * LINK token address:                0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06
     * Key Hash: 0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186
     *
     * ERC20-BUSD: 0x8301F2213c0eeD49a7E28Ae4c3e91722919B8B47
     * ICO Amount: 2500
     * Cost per egg: 5 Busd
     */
    constructor(){
        KaijuEggContract eggContract = new KaijuEggContract(2500, 0x8301F2213c0eeD49a7E28Ae4c3e91722919B8B47, 5 * 10**18);
        ProjectKaiju kaijuContract = ProjectKaiju(eggContract.getKaijuContract());
        FirstGenCreation creationContract = new FirstGenCreation(address(kaijuContract));
        BreedingCostCalculator calc = new DefaultBreedingCostCalculator(address(kaijuContract));
        KaijuBreeding breeding = new KaijuBreeding(address(eggContract));
        RandomNumberProvider chainlink = new RandomNumberConsumer(address(breeding), 0xa555fC018435bef5A13C6c6870a9d4C11DEC329C, 0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06, 0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c);
        breeding.setBreedingCalc(address(calc));
        breeding.setRngProvider(address(chainlink));

        address[] memory defaultOperator;
        defaultOperator[0] = address(breeding);
        
        KaijuScales ks = new KaijuScales(defaultOperator);
        CrystalMango cm = new CrystalMango(defaultOperator);
        
        breeding.setMango(address(cm));
        breeding.setKaijuScales(address(ks));
        kaijuContract.setCreationContract(address(creationContract));
        selfdestruct(payable(msg.sender));
    }
}
