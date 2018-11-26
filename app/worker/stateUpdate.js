import loadVote from './loadVote';
import toPromiseFunction from './toPromiseFunction';

// turn the loadVote observable into function returning a promise
let votePromiseFn = toPromiseFunction(loadVote);

async function stateUpdate(state, data) {
    if (state === null) {
        state = {
            votes: [],
        };
    }

    if (data.event == 'VoteCreated') {
        const vote = await votePromiseFn(data.returnValues[0]);
        state.votes.push(vote);
    }

    if (data.event == 'VoteCast') {
        const vote = await votePromiseFn(data.returnValues[0]);
        state.votes[vote.id] = vote;
    }
    return state;
  
}

export default stateUpdate;
