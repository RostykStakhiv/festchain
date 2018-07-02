class NRC720BaseToken {
	init(tokenName, tokenId, tokenOwnerId) {
		this._name = tokenName;
		this._tokenId = tokenId;
		this._tokenOwnerId = tokenOwnerId;
	}

	name() {
		return this._name;
	}

	tokenId() {
		return this.tokenId;
	}

	tokenOwnerId() {
		return this._tokenOwnerId;
	}
}

class FestChainTicket extends NRC720BaseToken {
	init(eventId, tokenId, ownerId) {
		super.init("FestChainTicket", tokenId, ownerId);
		this._eventId = eventId;
	}

	eventId() {
		return this._eventId;
	}
}

class FestChain {
	constructor() {
		LocalContractStorage.defineProperties(this, {
			eventsCount: {
				parse: function(value) {
				    return new BigNumber(value);
				},
				stringify: function(o) {
				    return o.toString(10);
				}
			},
			ticketsCount: {
				parse: function(value) {
				    return new BigNumber(value);
				},
				stringify: function(o) {
				    return o.toString(10);
				}
			},
		});

		LocalContractStorage.defineMapProperties(this, {
			eventsMapById: null,
			ticketOwnersMapById: {
				parse: function(value) {
				    return JSON.parse(value);
				},
				stringify: function(o) {
				    return JSON.stringify(o);
				}
			    },
			ticketsMapById: null,
		});
	}

	init() {
		this.eventsCount = new BigNumber(0);
		this.ticketsCount = new BigNumber(0);
	}
	
	//Public methods
	buyTicket(eventId) {
		let event = this.eventsMapById.get(eventId);

		if(!event) {
			throw new Error("There is no such event!");
		}

		let buyerId = Blockchain.transaction.from;
		let value = new BigNumber(Blockchain.transaction.value);

		if(value.div(1e18).gt(event.ticketPrice)) {
			throw new Error("You try to pay too much!");
		}

		if(value.div(1e18).lt(event.ticketPrice)) {
			throw new Error("Not enough NAS to purchase ticket!");
		}

		let ticketOwner = this.ticketOwnersMapById.get(buyerId);
		if(!ticketOwner) {
			ticketOwner = {
				id: buyerId,
				ticketIds: [],
			}
		}

		console.log(`buyTicket: Ticket owner = ${JSON.stringify(ticketOwner)}`);

		let ticket = this._createTicket(eventId, buyerId);

		console.log(`buyTicket: Created Ticket = ${JSON.stringify(ticket)}`);
		ticketOwner.ticketIds.push(ticket.id);

		console.log(`Ticket owner after buying ticket: ${JSON.stringify(ticketOwner)}`);
		this.ticketOwnersMapById.set(buyerId, ticketOwner);
	}

	//Get
	getAllEvents() {
		let res = [];
		for(let i = 1; i <= this.eventsCount; ++i) {
			let event = this.eventsMapById.get(i);
			res.push(event);
		}

		return res;
	}

	getUserTickets(ownerId) {
		let tickets = [];
		let owner = this.ticketOwnersMapById.get(ownerId);
		if(!owner) {
			return tickets;
		}

		let ticketIds = owner.ticketIds;
		ticketIds.forEach((ticketId) => {
			let ticket = this.ticketsMapById.get(ticketId);
			if(ticket) {
				tickets.push(ticket);
			}
		});

		return tickets;
	}

	getTicketOwnerById(ownerId) {
		let owner = this.ticketOwnersMapById.get(ownerId);
		return (owner) ? owner : {};
	}

	getTicketById(ticketId) {
		let ticket = this.ticketsMapById.get(ticketId);
		return (ticket) ? ticket : {};
	}

	getAllTickets() {
		let tickets = [];
		for(let i = 1; i <= this.ticketsCount; ++i) {
			let ticket = this.ticketsMapById.get(i);
			if(ticket) {
				tickets.push(ticket);
			}
		}

		return tickets;
	}

	//Create
    	createEvent(title, description, ticketPrice, maxNumberOfTickets) {
		let eventId = this._nextEventID();
		let creatorId = Blockchain.transaction.from;

		let createdEvent = {
            		id: eventId,
            		creatorId: creatorId,
            		title: title,
			description: description,
			maxNumberOfTickets: new BigNumber(maxNumberOfTickets),
			ticketPrice: new BigNumber(ticketPrice),
			ticketsSold: new BigNumber(0),
			creationDate: Date.now(),
		};
		
		console.log(createdEvent.toString());
		this.eventsMapById.set(eventId, createdEvent)
		this.eventsCount = eventId;
	}
	
	//Private methods
	_pay(to, amount) {
        	return Blockchain.transfer(to, amount)
	}
	
	_nextEventID() {
		return new BigNumber(this.eventsCount.plus(1));
	}

	_nextTicketID() {
		return new BigNumber(this.ticketsCount.plus(1));
	}

	_createTicket(eventId, ownerId) {
		console.log("Create ticket method");
		
		let nextTicketId = this._nextTicketID();
		let ticket = {
			id: nextTicketId,
			ownerId: ownerId,
			eventId: eventId,
		};

		this.ticketsCount = nextTicketId;

		console.log(`Created ticket: ${JSON.stringify(ticket)}, ticketId = ${ticket.id}`);
		this.ticketsMapById.set(ticket.id, ticket);
		return ticket;
	}
}

module.exports = FestChain;