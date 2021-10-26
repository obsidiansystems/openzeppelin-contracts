// SPDX-License-Identifier: MIT

/**
 * @title EyeLid
 * 
 * 
 * 
 * 
 * 
 * EyeCon by Sarah Meyohas
 *     www.EyeCon.com
 */
pragma solidity ^0.8.0;

import "./EyeCon.sol";
import "../../../access/Ownable.sol";

contract EyeLid is EyeCon, Ownable {
    uint256 private NFT_id = 0; 
    uint256[] private qty = [10000000, 1]; 
    uint256 private _world_pop = 0;
    uint256[] private ids = [0,NFT_id];
    uint public price = 10000000 wei;
    address payable public artist;
    constructor(string memory uri, address payable artist_)
        EyeCon(uri)
    {
        artist = artist_;
    }

    function mint_eyecon() public payable virtual returns (uint256) {

        //Limit total number of NFTs to the current world_pop(in Billions of people) 
        require(NFT_id < world_pop(), "EyeLid: world population set too low to mint more");

        //Require mint_eyecon to include the current price
        require(msg.value >= price, "EyeLid: please include the current price with your transaction");
            NFT_id ++;
            address buyer = _msgSender();
            mintBatch(buyer, ids, qty, "0x00");
            artist.transfer(price);
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

    function set_price(uint256 new_price) public virtual {
        require (hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "EyeLid: must have admin role to change price");
        price = new_price;
    }

    function set_artist(address payable _artist) public virtual {
        require (hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "EyeLid: must have admin role to change artist");
        artist = _artist;
    }
    
}
