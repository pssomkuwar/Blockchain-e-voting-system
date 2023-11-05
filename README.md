# VotingSmartContract README

This README provides a detailed explanation of the "VotingSmartContract" written in Solidity.

## Table of Contents

- [Introduction](#introduction)
- [Smart Contract Overview](#smart-contract-overview)
- [Contract State Variables](#contract-state-variables)
- [Structs](#structs)
- [Modifiers](#modifiers)
- [Functions](#functions)
- [Events](#events)
- [Usage](#usage)
- [License](#license)

## Introduction

The "VotingSmartContract" is a Solidity smart contract for managing a voting system. It allows users to register as voters, register contestants, and cast votes for their favorite contestants.

## Smart Contract Overview

- **Owner**: The owner of the contract, who has special privileges.
- **Voting Sessions**: The contract supports multiple voting sessions.
- **Contestants**: Contestants are individuals or entities users can vote for.
- **Voters**: Registered users who can vote for contestants.
- **Max Votes Per Session**: The maximum number of votes a user can cast in a single session.

## Contract State Variables

1. **owner**: The Ethereum address of the contract owner.
2. **votingStartTime**: Timestamp when the current voting session starts.
3. **votingEndTime**: Timestamp when the current voting session ends.
4. **currentSession**: The current voting session number.
5. **contestantCount**: The total number of registered contestants.
6. **isFirstSession**: A flag to track the first session.
7. **contestants**: An array to store contestant details.
8. **registeredVoters**: A mapping to track registered voters.
9. **voters**: A mapping of voters and their voting history.
10. **remainingVotes**: A mapping to track the remaining votes for voters.
11. **maxVotesPerSession**: Maximum votes allowed per session (constant).

## Structs

1. **Contestant**: A struct representing contestant details, including name, age, location, IPFS hash for an image, description, and total votes received.
2. **Voter**: A struct representing voter details, including the history of their votes in each session.

## Modifiers

1. **onlyOwner**: Ensures that only the contract owner can call certain functions.
2. **votingOpen**: Checks if voting is currently open.
3. **voterRegistered**: Ensures that a user is registered to vote.
4. **sessionEnded**: Ensures that a voting session has ended before proceeding with certain operations.

## Functions

- **startNewSession**: Initiates a new voting session.
- **registerContestant**: Allows the contract owner to register new contestants.
- **registerVoter**: Allows users to register as voters.
- **vote**: Allows registered voters to cast votes for contestants.
- **getContestantCount**: Returns the total number of contestants.
- **getContestantInfo**: Returns details about a specific contestant.
- **getVoterVotes**: Returns the number of votes a voter has cast for a contestant in a given session.
- **getCurrentSession**: Returns the current voting session number.
- **getVotersRemainingCurrentSessionVotes**: Returns the remaining votes for a voter in the current session.
- **getVoterSessionVotes**: Returns the number of votes a voter has cast for a contestant in a specific session.
- **isVotingOpen**: Checks if voting is currently open.
- **setVotingEndTime**: Allows the owner to set the end time for the current session.

## Events

- **ContestantRegistered**: Fired when a contestant is registered.
- **Voted**: Fired when a voter casts votes for a contestant.
- **NewVotingSession**: Fired when a new voting session is initiated.

## Usage

1. Deploy the smart contract to an Ethereum network.
2. The contract owner can register contestants using the `registerContestant` function.
3. Users can register as voters using the `registerVoter` function.
4. Registered voters can cast votes for contestants using the `vote` function.
5. Various functions allow querying contestant information and voting history.
6. The contract owner can set the end time for voting sessions using `setVotingEndTime`.

## License

This smart contract is released under the MIT License.

