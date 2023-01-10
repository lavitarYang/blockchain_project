// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MainContract {
    address public admin;
    bool start = false;
    uint256 player = 0;
    rank[] public forb;
    struct rank {
        address player_address;
        uint256 asset;
    }

    function onchainSort() external onlyOwner {
        for (uint256 i = 0; i < player; i++) {
            forb.push(rank(key[i], paticipants_storage[key[i]].asset));
        }
        for (uint256 i = 1; i < player; i++) {
            for (uint256 j = 0; j < player - i; j++) {
                if (forb[j].asset < forb[j + 1].asset) {
                    rank memory temp = forb[j];
                    forb[j] = forb[j + 1];
                    forb[j + 1] = temp;
                }
            }
        }
    }

    function getRank() external view returns (rank[] memory) {
        return forb;
    }

    modifier notStart() {
        require(start == false, "is not allow to add fund after started");
        _;
    }
    enum Shop {
        Butcher,
        Backery
    }
    modifier onlyOwner() {
        require(admin == msg.sender, "only owner can do this");
        _;
    }
    modifier quolify() {
        require(
            paticipants_storage[msg.sender].partin == true,
            "you are bankrupt"
        );
        _;
    }
    struct PlayerInfo {
        uint256 balance;
        uint256 asset;
        uint256 business;
        bool partin;
        bool bought;
    }
    //state variable
    /*  paticipants_storage : 
                        1. at least 5 member to game
                        2. asset is 10 times bank_balance.
                        3. out default as false
        
        business    :   1. each business has its cost and sell price 
                           and they are with respect to event ,
                           that it should be a dict like struct.
                        2. there should be default cost and sell price for em.
    */
    mapping(uint256 => address) public key;
    mapping(address => PlayerInfo) public paticipants_storage;
    mapping(Shop => uint256[2]) public shops_storeage;

    constructor() {
        admin = msg.sender;
        shops_storeage[Shop(0)][0] = 10;
        shops_storeage[Shop(0)][1] = 15;
        shops_storeage[Shop(1)][0] = 15;
        shops_storeage[Shop(1)][1] = 25;
    }

    // ----------------------owner utility              ----------------
    // besure to invoke with accounts[0]
    // app.started({from:accounts[0]})
    function started() external onlyOwner {
        start = true;
    }

    function tick() external onlyOwner {
        set_Shop_Storage();
        for (uint256 i = 0; i < player; i++) {
            paticipants_storage[key[i]].asset -= 100;
            if (paticipants_storage[key[i]].asset <= 0) {
                paticipants_storage[key[i]].partin = false;
            }
            paticipants_storage[key[i]].bought = false;
        }
    }

    function getStorageUint() external view returns (uint256) {
        return paticipants_storage[msg.sender].balance;
    }

    // ----------------------add fund to contract owner ----------------
    /*  after deploy contract 
        first add some fund to start some function
        use syntax 
        ```
        await maincontract.addFundToContract(maincontract.address,{from:msg.sender,value:web3.utils.toWei('1','Ether')})
        ```
        player could not use this to participant
     */
    receive() external payable {}

    fallback() external payable {}

    function balanceOfContract() public view returns (uint256) {
        return address(this).balance;
    }

    function ownerSender(address payable _to) external payable onlyOwner {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "fail");
    }

    // ----------------------shop utility-----------------------------

    function getShop(uint256 _i) external view returns (uint256[2] memory) {
        return shops_storeage[Shop(_i)];
    }

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

    function set_Shop_Storage() public onlyOwner {
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
    modifier paidfirst() {
        require(
            (paticipants_storage[msg.sender].balance > 0),
            "pay to participant"
        );
        _;
    }

    function buy(uint256 _amount) external paidfirst quolify {
        if (paticipants_storage[msg.sender].bought == true)
            revert("you already bought today");
        uint256 volumn = _amount *
            shops_storeage[Shop(paticipants_storage[msg.sender].business)][0];
        if (paticipants_storage[msg.sender].asset < volumn)
            revert("not enough money to operate");
        uint256 roi = _amount *
            shops_storeage[Shop(paticipants_storage[msg.sender].business)][1];
        paticipants_storage[msg.sender].asset += (roi - volumn);
        paticipants_storage[msg.sender].bought = true;
    }

    function chooseShop(uint256 _i) external notStart {
        require(_i < 2 && _i >= 0, "no such choice");
        paticipants_storage[msg.sender].business = _i;
    }

    function playerSender(address payable _to) external payable notStart {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "fail");
        paticipants_storage[msg.sender].balance += msg.value;
    }

    function initPlayerState() external paidfirst {
        paticipants_storage[msg.sender].asset =
            paticipants_storage[msg.sender].balance *
            10;
        paticipants_storage[msg.sender].partin = true;
        key[player] = msg.sender;
        player += 1;
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
