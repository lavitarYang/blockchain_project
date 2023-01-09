// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Bank.sol";

contract MainContract {
    address public admin;
    address bank_interface;
    enum Shop {
        Butcher,
        Backery
    }
    modifier onlyOwner() {
        if (admin == msg.sender) revert("only owner can do this");
        _;
    }
    struct PlayerInfo {
        uint256 bank_balance;
        uint256 asset;
        Shop business;
        bool out;
    }
    //state variable
    /*  paticipants_storage :   1. no restriction for number of player.
                        2. asset is 10 times bank_balance.
                        3. out default as false
        
        business    :   1. each business has its cost and sell price 
                           and they are with respect to event ,
                           that it should be a dict like struct.
                        2. there should be default cost and sell price for em.
    */
    mapping(address => PlayerInfo) public paticipants_storage;
    mapping(Shop => uint256[2]) public shops_storeage;

    constructor() {
        admin = msg.sender;
        shops_storeage[Shop(0)][0] = 10;
        shops_storeage[Shop(0)][1] = 15;
        shops_storeage[Shop(1)][0] = 15;
        shops_storeage[Shop(1)][1] = 25;
    }

    // ----------------------instantiate interface--------------------
    /*  it has to be called out off B and in order
        bankInstance = await Bank.deployed()
        app          = await MainContract.depolyed()
        await app.depoBank(bankInstance.address);
            -after done above job then move to bank utility section
            -for instance:
        response = await app.Bank_response()
        balance  = await app.Bank_getbalance()
     */
    function depoBank(address _a) external {
        bank_interface = _a;
    }

    // ----------------------bank utility-----------------------------
    function Bank_getbalance() external view returns (uint256) {
        Bank bank_instance = Bank(bank_interface);
        return bank_instance.getbalance();
    }

    function Bank_response() external view returns (string memory) {
        Bank bank_instance = Bank(bank_interface);
        return bank_instance.response();
    }

    // ----------------------shop utility-----------------------------

    function getShop(uint256 _i) external view returns (uint256[2] memory) {
        return shops_storeage[Shop(_i)];
    }

    // function selectShop(uint256 _i) external {
    //     if (_i < 2 && _i >= 0)
    //         revert("there are currently two types of shop to chose");
    // }

    //price offset
    function getOffset() internal view returns (uint256) {
        return (seed % 5) + 1;
    }

    /*  random again for decrese or increase
        0:increse+offset
        1:decrese-offset
    */
    function getOrder() internal view returns (uint256) {
        return seed % 2;
    }

    function set_Shop_Storage() external {
        for (uint256 i = 0; i < 2; i++) {
            random();
            uint256 offset = getOffset();
            uint256 order = getOrder();
            if (order == 0) {
                //add cost
                //low price
                shops_storeage[Shop(i)][0] += offset;
                shops_storeage[Shop(i)][1] -= offset;
            } else {
                //low cost
                //add price
                shops_storeage[Shop(i)][0] -= offset;
                shops_storeage[Shop(i)][1] += offset;
            }
        }
    }

    // ----------------------player utility-----------------------------
    //initiallize for default state
    /*initState(accounts[0],[bank_balance,bank_balance*10,enumShop])
     */
    function initPlayerState(address _a, PlayerInfo calldata _p) public {
        PlayerInfo memory p;
        // if()asdfsdfa
        paticipants_storage[_a] = _p;
    }

    //has to be view from
    function getPlayerState(address _a)
        public
        view
        returns (PlayerInfo memory)
    {
        return paticipants_storage[_a];
    }

    // ----------------------random utility-----------------------------
    // this function would be call while each time period colck
    uint256 seed = 0;

    function random() internal {
        seed = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp, seed))
        );
    }
    //-----------------------------------------------------------
}
