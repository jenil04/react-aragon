import app from './app';

/**
 * Returns an observable that will call for votes by their id and transform the data received
 * @param {number} id
 * @returns {observable}
 */
function loadVote(id) {
  return app.call('votes', id )
  			.map((vote) => {
				  return {
					  yes: parseInt(vote.yes),
					  no: parseInt(vote.no),
					  id,
					  creator: vote.creator,
					  question: vote.question,
				  }
    			/* return all vote properties, add the vote id, and transform yes/no counts */
  			})
}

export default loadVote;
