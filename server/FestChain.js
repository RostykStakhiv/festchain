class FestChainTickets {
	constructor() {
		// define fields stored to state trie
		LocalContractStorage.defineProperties(this, {
			eventsCount: null,
		});

		LocalContractStorage.defineMapProperties(this, {
			eventsMapById: null,
			ticketOwnersMapById: null,
		});
	}

	init() {
		this.eventsCount = new BigNumber(0);
	}
	
	//Public methods
	buyTicket(eventId) {
		let buyerId = Blockchain.transaction.from;
		let ticketOwner = this.ticketOwnersMapById.get(buyerId);

		let ticket = this._createTicket(eventId);

		if(!ticketOwner) {
			ticketOwner = {
				id: buyerId,
				ticketIds: new Set(),
			}
		}

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

	_createTicket(eventId) {
		//Code to create ticket token
		let ticket = {
			id: 0,
			eventId: eventId,
		}

		return ticket;
	}
}

module.exports = FestChainTickets;