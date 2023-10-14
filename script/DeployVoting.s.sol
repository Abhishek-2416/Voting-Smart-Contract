// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";

contract DeployVoting is Script{
    function setUp() public{
        Voting voting;
    }
}