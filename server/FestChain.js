class NRC720BaseToken {
	init(tokenName, tokenId, tokenOwnerId) {
		LocalContractStorage.defineProperties(this, {
			_name: null,
			_tokenId: null,
			_tokenOwnerId: null,
		})

		this._name = tokenName;
		this._tokenId = tokenId;
		this._tokenOwnerId = tokenOwnerId;
	}

	name() {
		return this._name;
	}

	tokenOwnerId() {
		return this._tokenOwnerId;
	}
}

class FestChainTicket extends NRC720BaseToken {
	static kTokenName = "FestChainTicket";
	init(eventId, tokenId, ownerId) {
		super.init(FestChainTicket.kTokenName, tokenId, ownerId);

		LocalContractStorage.defineProperties(this, {
			_eventId: null,
		});

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
		});
	}

	init() {
		this.eventsCount = new BigNumber(0);
		this.ticketsCount = new BigNumber(0);
	}
	
	//Public methods
	buyTicket(eventId) {
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
		return new FestChainTicket(eventId, this._nextTicketID(), ownerId);
	}
}

module.exports = FestChain;