// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract event_organization {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

    mapping(uint => Event) public Events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextid;

    // Create an event
    function createEvent(string memory _name, uint _date, uint _price, uint _ticketCount) public {
        require(_date > block.timestamp, "Event date must be in the future");
        require(_ticketCount > 0, "Ticket count must be greater than 0");
        Events[nextid] = Event(msg.sender, _name, _date, _price, _ticketCount, _ticketCount);
        nextid++;
    }

    // Buy tickets for an event
    function buyTicket(uint _id, uint quantity) external payable {
        require(Events[_id].date != 0, "This event does not exist");
        require(Events[_id].date > block.timestamp, "Event has already occurred");
        Event storage EventS = Events[_id];
        require(msg.value == EventS.price * quantity, "Ether sent is not correct");
        require(EventS.ticketRemaining >= quantity, "Not enough tickets available");

        EventS.ticketRemaining -= quantity;
        tickets[msg.sender][_id] += quantity;
    }

    // Transfer tickets to another address
    function transferTicket(uint id, uint quantity, address to) external {
        require(Events[id].date != 0, "This event does not exist");
        require(Events[id].date > block.timestamp, "Event has already occurred");
        require(tickets[msg.sender][id] >= quantity, "You don't have enough tickets");

        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}





























