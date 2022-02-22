pragma solidity >= 0.8;

import "./Kaiju.sol";

interface KaijuCreation{
    function CreateKaiju(KaijuEgg memory) external returns(Kaiju memory);
}
