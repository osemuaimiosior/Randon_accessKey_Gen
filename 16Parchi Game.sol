// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolahParchiThap {
    address owner = msg.sender;
    address[4] p;
    uint8[4][4] aparchis;
    uint endgame;
    uint newgame;
    uint startTime;
    uint8 turn;
    uint id;
    uint8 value;
    
    modifier onlyOwner {require(msg.sender == owner); _;}

    mapping (address => uint8[4]) _players;
    mapping(uint => mapping(address => bool)) allPlayers;
    mapping(address => uint) users;
    mapping(address => uint256) wins;

    // To set and start the game
    function setState(address[4] memory players, uint8[4][4] memory parchis) public onlyOwner returns (string memory){
       require(newgame == 0, "Game is currently in session");
        aparchis = parchis;
        uint q;
        
        for ( uint s; s < 4; s++){ 
                q = aparchis[s][0] + aparchis[s][1] + aparchis[s][2] + aparchis[s][3];
                require(q > 2 && q < 6);
            }
        

      for( uint ad; ad < 4; ad++){
        require(players[ad] != address(0));
       }


      for (uint i=0; i < players.length; i++){
            if (players[i] == owner){
                return ("Owner can not be a player");
            } else {
                 allPlayers[id][players[i]] = true;
                _players[players[i]] = parchis[i];
                users[players[i]] = id;
                id += 1;
            }
        } p = players;    

        startTime = uint(block.timestamp);
        return ("Succeeded");
    }

    // To pass the parchi to next player
    function passParchi(uint8 parchi) public returns (string memory) {
        uint8 member = checkP();
        require (member != 7, "You are not a vaild memebr of this game");
        require (parchi != 0, "Parchi position can not be zero, start from 1");
        
       unchecked{ if(newgame == 0){
            turn = 0;
        }
        
        require(member == turn, "It is not your turn to play the game");
        require(checkP() != 7, "You are not a valid player");
        require(_players[msg.sender][parchi - 1] > 0, "Not enough parchis to play");
        require(parchi <= 4, "Invalid input");
        
        if(turn == 3){
            turn = 0;
            value = _players[msg.sender][parchi -1];
            if(value == 1){
                _players[p[turn]][parchi-1] += value;
                _players[msg.sender][parchi-1] = _players[msg.sender][parchi-1] - 1;
                aparchis[member] = _players[msg.sender];
                aparchis[turn] = _players[p[turn]];
            } else{
                  _players[p[turn]][parchi-1] += value -1;
                _players[msg.sender][parchi-1] = _players[msg.sender][parchi-1] - 1;
                aparchis[member] = _players[msg.sender];
                aparchis[turn] = _players[p[turn]];
            }
          
        } else{
            value = _players[msg.sender][parchi-1];
            if (value == 1){
                _players[p[turn+1]][parchi-1] += value;
            _players[msg.sender][parchi-1] = _players[msg.sender][parchi-1] - 1;
            aparchis[member] = _players[msg.sender];
            aparchis[turn+1] = _players[p[turn+1]];
            turn = member + uint8(1);
            } else{
                    _players[p[turn+1]][parchi-1] += value -1 ;
                _players[msg.sender][parchi-1] = _players[msg.sender][parchi-1] - 1;
                aparchis[member] = _players[msg.sender];
                aparchis[turn+1] = _players[p[turn+1]];
                turn = member + uint8(1);
            }
        }
        
        newgame = 1;

        return ("Done");
    }}


    // To claim win
    function claimWin() public returns (string memory) {
        uint v = checkP();
        require (v != 7, "You are not a vaild memebr of this game");

        uint8[4] memory dt =_players[msg.sender];

        for (uint8 e; e < 4; e++){
            if(4 == dt[e]){
                wins[msg.sender] += 1;
                newgame = 0;
                p[0] = p[1] = p[2] = p[3] = address(0);
                return ("Won");
            } 
        }

        revert();
    }


    //To end the game
    function endGame() public {
        newgame = 0;
        p[0] = p[1] = p[2] = p[3] = address(0);
    }


    //To see the number of wins
    function getWins(address add) public view returns (uint256) {
        require(add != address(0) && add != owner);
        
        return (wins[add]);
    }


     // To see the parchis held by the caller of this function
    function myParchis() public view returns (uint8[4] memory) {
        require (checkP() != 7, "You are not a vaild memebr of this game");

        uint8[4] memory data =_players[msg.sender];

        return (data);
    }

    // To get the state of the game
    function getState() public view  returns (address[4] memory players_, address _turn, uint8[4][4] memory game) {
        
        _turn = p[turn];
        game = aparchis;
        return (p, _turn, game);

    }


    function checkP() view internal returns (uint8){
        for (uint8 i; i < 4; i++){
            if(msg.sender == p[i]) return i;
        } return 7;
    }


     function newGame() internal {
        newgame = 1;
    }

}
