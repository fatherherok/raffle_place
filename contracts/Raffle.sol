// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

error Raffle__SendMoreToEnterRaffle();
error Raffle__RaffleNotOpen();
error Raffle__UpkeepNotNeeded();

contract Raffle {

    enum RaffleState {
        Open,
        Calculating
    }

    RaffleState public s_raffleState; //this is a storage variable

    uint256 public immutable i_entraceFee; 
     uint256 public immutable i_interval; 
    address payable[] public s_players;
    uint256 public s_lastTimeStamp;

    event RaffleEnter(address indexed player);

    //with immutable keywprds cannot be changd, it is cheaper variable to use .............

    constructor(uint256 entranceFee, uint256 interval){
        i_entraceFee = entranceFee;
         i_interval = interval;
         s_lastTimeStamp = block.timestamp;
    }

        function enterRaffle() external payable {
            //require(msg.value >= i_entraceFee), "not enough money sent";
            // require keyword is very expensive to use, so use..........
                if(msg.value < i_entraceFee  ){
                    revert Raffle__SendMoreToEnterRaffle(); 
                }
            
            //Open, calculating a winner


            if(s_raffleState != RaffleState.Open){
                 revert Raffle__RaffleNotOpen(); 
            }

            s_players.push(payable(msg.sender));
            emit RaffleEnter((msg.sender));
            
        }


        //hhow to make the raffle done automatically
        //how to be a real random users

        //be true after some time interval
        //the lottery to be open
        //the contract has ETH
        //keepers has LINK
        function checkUpKeep(bytes memory) public view returns(bool upKeepNeeded, bytes memory){

            bool isOpen = RaffleState.Open == s_raffleState;
            bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
            bool hasBalance = address(this).balance > 0;
            upKeepNeeded = (timePassed && isOpen && hasBalance);
            return (upKeepNeeded, "0x0");
        }
        
        function performUpKeep(bytes calldata) external{
            (bool upKeepNeeded, ) = checkUpKeep("");
            if(!upKeepNeeded){
                revert Raffle__UpkeepNotNeeded();
                 
            }
        s_raffleState = RaffleState.Calculating;
        }





    }