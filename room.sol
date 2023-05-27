// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Room is Ownable {
    using Strings for *;
    uint public room_number;
    uint internal room_price; // room price in wei
    enum Statuses { Free, Booked }
    Statuses public current_status;

    constructor(uint _rnum, uint _room_price_in_wei) {
        room_number = _rnum;
        current_status = Statuses.Free;
        room_price = _room_price_in_wei;
    }

    // Check if the room is free or not
    function isFree() public view returns (string memory) {
        require(current_status == Statuses.Free, "This room is not currently free.");
        return "This room is free, you can proceed to book.";
    }

    // admin can change the room number if necessary
    function change_room_number(uint _new_num) public onlyOwner {
        room_number = _new_num;
    }


    // getting the price of the room
    function get_room_price() public view returns(uint) {
        return room_price;
    }

    // booking room
    function book_room() public payable {
        require(current_status==Statuses.Free, "The room is currently booked. Wait for it to be free.");
        require(msg.value == room_price, "Not enough or too much ether sent");
        (bool sent, bytes memory msg1) =  payable(owner()).call{value: msg.value}("");
        require(sent, "Transaction did not succeeded.");
        current_status = Statuses.Booked;

    }

}
