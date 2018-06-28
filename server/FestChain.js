class FestChain {
	constructor() {

		// define fields stored to state trie
		LocalContractStorage.defineProperties(this, {
			eventsCount: null,
		});

		LocalContractStorage.defineMapProperties(this, {
            eventsMapById: null,
        });
	}

	init() {
        this.eventsMapById = new BigNumber(0);
	}
	
	getNextEventId() {
        return {
            id: new BigNumber(this.eventsCount).plus(1)
        };
    }
}

module.exports = FestChain;