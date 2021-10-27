// SPDX-License-Identifier: MIT

/**
 * @title EyeLid
 * 
 * 
 * 
 * 
 * 
 * Eyecon/Eyecoin by Sarah Meyohas
 * 
 * ID 0: Fungible Eyecoins
 * ID 1+: Eyecon NFTs
 * 
 * 
 */
pragma solidity ^0.8.0;

import "./EyeCon.sol";
import "../../../access/Ownable.sol";

contract EyeLid is EyeCon, Ownable {
    uint256 private NFT_id = 0; 
    uint256 private _world_pop = 0;
    address payable private _artist;
    uint256 private _price = 79000000000000000;
    uint256[] private qty = [10000000, 1]; 
    uint256[] private ids = [0, 0];
    constructor(string memory uri)
        EyeCon(uri)
    {
        _artist = payable(_msgSender());
    }

    function mint_eyecon() public payable virtual returns (uint256) {

        //Limit total number of NFTs to the current world_pop(in Billions of people) 
        require(NFT_id < world_pop(), "EyeLid: world population set too low to mint more");

        //Require mint_eyecon to include the current price
        require(msg.value >= _price, "EyeLid: please include the current price with your request");
            NFT_id ++;
            address buyer = _msgSender();
            ids = [0, NFT_id];
            mintBatch(buyer, ids, qty, "");
            _artist.transfer(msg.value);
            return NFT_id;
    }

    function world_pop() public view returns (uint256) {
        return _world_pop;
    }

    function set_world_pop(uint256 new_pop) public virtual {
        require (hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "EyeLid: must have admin role to change population");
        require (new_pop > _world_pop, "EyeLid: population can only be increased");
        _world_pop = new_pop;
    }

    function price() public view returns (uint256) {
        return _price;
    }

    function set_price(uint256 new_price) public virtual {
        require (hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "EyeLid: must have admin role to change price");
        _price = new_price;
    }

    function artist() public view returns (address payable) {
        return _artist;
    }

    function set_artist(address payable new_artist) public virtual {
        require (hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "EyeLid: must have admin role to change artist");
        _artist = new_artist;
    }
    
}
