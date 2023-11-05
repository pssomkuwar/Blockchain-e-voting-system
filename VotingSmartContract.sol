// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSmartContract {
    address public owner;
    uint public votingStartTime;
    uint public votingEndTime;
    uint public currentSession;
    uint public contestantCount; // Tracks the total number of contestants;
    bool public isFirstSession = true; // Flag to track the first session

    struct Contestant {
        string name;
        uint age;
        string location;
        string ipfsHash; // IPFS hash for contestant image.
        string description;
        uint totalVotes; // Total votes received throughout the season.
    }

    Contestant[] public contestants;

    struct Voter {
        mapping(uint => mapping(uint => uint)) sessionVotes; // Mapping of session to votes given to each contestant.
    }

    mapping(address => mapping(uint => bool)) public registeredVoters;
    mapping(address => Voter) private voters; // Make the mapping private.
    mapping(address => mapping(uint => uint)) private remainingVotes;

    uint constant public maxVotesPerSession = 10; // Maximum votes per session (constant).

    event ContestantRegistered(uint indexed contestantIndex);
    event Voted(address indexed voter, uint indexed contestantIndex, uint votes, uint session);
    event NewVotingSession(uint session);

    constructor() {
        owner = msg.sender;
        currentSession = 0;
        //votingEndTime = block.timestamp;
        isFirstSession = true;
        startNewSession();
        contestantCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier votingOpen() {
        require(block.timestamp >= votingStartTime && block.timestamp <= votingEndTime, "Voting is not open.");
        _;
    }

    modifier voterRegistered() {
        require(maxVotesPerSession > 0, "maxVotesPerSession not set.");
        require(registeredVoters[msg.sender][currentSession],"Voter Not Registered!");
        require(remainingVotes[msg.sender][currentSession] > 0, "You have used all your votes for this session.");
        _;
    }

    modifier sessionEnded() {
        bool flag = block.timestamp >= votingStartTime && block.timestamp <= votingEndTime;
        require(!flag, "Current session has not ended yet in session Endded Modifier.");
        _;
    }

    function startNewSession() internal sessionEnded {
        currentSession++;
        votingStartTime = block.timestamp;
        emit NewVotingSession(currentSession);
    }

    function registerContestant(string memory _name, uint _age, string memory _location, string memory _ipfsHash, string memory _description) public onlyOwner {
        contestants.push(Contestant(_name, _age, _location, _ipfsHash, _description, 0));
        emit ContestantRegistered(contestantCount);
        contestantCount++;
    }

        function registerVoter() public {
        //Voter storage voter = voters[msg.sender];
        require(!registeredVoters[msg.sender][currentSession],"Voter Already Registered!");
        //require(voter.sessionVotes[currentSession][0] == 0, "You are already registered as a voter for this season.");
        registeredVoters[msg.sender][currentSession] = true;
        remainingVotes[msg.sender][currentSession] = maxVotesPerSession;
    }


    function vote(uint contestantIndex, uint votes) public votingOpen voterRegistered {
        require(contestantIndex < contestantCount, "Invalid contestant index");
        require(votes > 0 && votes <= maxVotesPerSession, "Invalid number of votes");
        
        Voter storage voter = voters[msg.sender];
        uint remaining = remainingVotes[msg.sender][currentSession];

        require(remaining >= votes, "Exceeding maximum votes allowed for this session");

        Contestant storage selectedContestant = contestants[contestantIndex];

        selectedContestant.totalVotes += votes; // Update total votes for the contestant.

        uint sessionVotes = voter.sessionVotes[currentSession][contestantIndex];
        voter.sessionVotes[currentSession][contestantIndex] = sessionVotes + votes; // Update session-wise votes for the voter and contestant.

        remainingVotes[msg.sender][currentSession] -= votes; // Deduct the votes from the remaining votes.

        emit Voted(msg.sender, contestantIndex, votes, currentSession);
    }


    function getContestantCount() public view returns (uint) {
        return contestantCount;
    }

    function getContestantInfo(uint contestantIndex) public view returns (string memory, uint, string memory, string memory, string memory, uint) {
        require(contestantIndex < contestantCount, "Invalid contestant index");
        Contestant storage c = contestants[contestantIndex];
        return (c.name, c.age, c.location, c.ipfsHash, c.description, c.totalVotes);
    }

    function getVoterVotes(uint session, uint contestantIndex) public view returns (uint) {
        require(registeredVoters[msg.sender][currentSession],"Voter Not Registered!");
        return voters[msg.sender].sessionVotes[session][contestantIndex];
    }

    function getCurrentSession() public view returns (uint) {
        return currentSession;
    }

    function getVotersRemainingCurrentSessionVotes() public view returns (uint) {
        require(registeredVoters[msg.sender][currentSession],"Voter Not Registered!");
        return remainingVotes[msg.sender][currentSession];
    }
    
    function getVoterSessionVotes(address voterAddress, uint session, uint contestantIndex) public view returns (uint) {
        return voters[voterAddress].sessionVotes[session][contestantIndex];
    }
    
    function isVotingOpen() public view returns (bool) {
    return block.timestamp >= votingStartTime && block.timestamp <= votingEndTime;
    }

    function setVotingEndTime(uint time, uint timeUnit) public onlyOwner {
        require(time > 0, "Time must be greater than zero");
        if (isFirstSession) {
            // If it's the first session, allow setting time without session ended check
            require(timeUnit >= 1 && timeUnit <= 3, "Invalid time unit.");
            if (timeUnit == 1) {
                // Time is in minutes.
                votingStartTime = block.timestamp;
                votingEndTime = block.timestamp + time * 1 minutes;
                isFirstSession = false;
                currentSession++;
            } else if (timeUnit == 2) {
                // Time is in seconds.
                votingStartTime = block.timestamp;
                votingEndTime = block.timestamp + time;
                isFirstSession = false;
                currentSession++;
            } else if (timeUnit == 3) {
                // Time is in hours.
                votingStartTime = block.timestamp;
                votingEndTime = block.timestamp + time * 1 hours;
                isFirstSession = false;
                currentSession++;
            }
        } else {
            // For subsequent sessions, require session ended before changing the time
            bool flag = block.timestamp >= votingStartTime && block.timestamp <= votingEndTime;
            require(!flag, "Current session has not ended yet inNew Session Functiomn.");
            require(timeUnit >= 1 && timeUnit <= 3, "Invalid time unit.");
            if (timeUnit == 1) {
                // Time is in minutes.
                //votingStartTime = block.timestamp;
                votingEndTime = block.timestamp + time * 1 minutes;
                votingStartTime = block.timestamp;
                currentSession++;
            } else if (timeUnit == 2) {
                // Time is in seconds.
                //votingStartTime = block.timestamp;
                votingEndTime = block.timestamp + time;
                votingStartTime = block.timestamp;
                currentSession++;
            } else if (timeUnit == 3) {
                // Time is in hours.
                //votingStartTime = block.timestamp;
                votingEndTime = block.timestamp + time * 1 hours;
                votingStartTime = block.timestamp;
                currentSession++;
            }
        }
    }
}
