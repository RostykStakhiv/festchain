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
	static kTokenName = "FestChainTicket";

	init(eventId, tokenId, ownerId) {
		super.init(FestChainTicket.kTokenName, tokenId, ownerId);
		this._eventId = eventId;
	}

	eventId() {
		return this._eventId;
	}
}

class FestChain {
	constructor() {
		LocalContractStorage.defineProperties(this, {
			eventsCount: null,
			ticketsCount: null,
		});

		LocalContractStorage.defineMapProperties(this, {
			eventsMapById: null,
			ticketOwnersMapById: null,
			ticketsMapById: null,
		});
	}

	init() {
		this.eventsCount = new BigNumber(0);
		this.ticketsCount = new BigNumber(0);
	}
	
	//Public methods
	buyTicket(eventId) {
		if(!this.eventsMapById.get(eventId)) {
			throw new Error("There is no such event!");
		}

		let buyerId = Blockchain.transaction.from;
		let ticketOwner = this.ticketOwnersMapById.get(buyerId);
		if(!ticketOwner) {
			ticketOwner = {
				id: buyerId,
				ticketIds: new Set(),
			}
		}

		let ticket = this._createTicket(eventId);

		ticketOwner.ticketIds.add(ticket.id);
		this.ticketOwnersMapById.set(buyerId, ticketOwner);
	}

	//Create
    	createEvent(title, description, maxNumberOfTickets) {
		let eventId = _nextEventID();
		let creatorId = Blockchain.transaction.from;

		let createdEvent = {
            		id: eventId,
            		creatorId: creatorId,
            		title: title,
			description: description,
			maxNumberOfTickets: maxNumberOfTickets,
			ticketsSold: 0,
			creationDate: Date.now(),
		};
		
		this.eventsMapById.set(eventId, createdEvent)
		this.eventsCount = eventId;
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
		for(let ticketId of ticketIds) {
			let ticket = this.ticketsMapById.get(ticketId);
			if(ticket) {
				tickets.push(ticket);
			}
		}

		return tickets;
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
		let ticket = new FestChainTicket(eventId, this._nextTicketID(), ownerId);
		this.ticketsMapById.set(ticket.tokenId, ticket);
		return ticket;
	}
}

module.exports = FestChain;