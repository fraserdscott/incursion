// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById } from "solecs/utils.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.Move"));

contract MoveSystem is System {
  enum Direction {
    Up,
    Down,
    Left,
    Right
  }

  constructor(IWorld _world, address _components) System(_world, _components) {}

  function add(Coord memory a, Coord memory b) private pure returns (Coord memory) {
    return Coord(a.x + b.x, a.y + b.y);
  }

  // If there is anything with a position in front of them, stop
  // Basically do getEntitiesWithValue for where they want to move
  function execute(bytes memory arguments) public returns (bytes memory) {
    Direction direction = abi.decode(arguments, (Direction));
    uint256 entity = uint256(uint160(msg.sender));

    PositionComponent position = PositionComponent(getAddressById(components, PositionComponentID));

    Coord memory force;

    if (direction == Direction.Up) {
      force.y = 1;
    } else if (direction == Direction.Down) {
      force.y = -1;
    } else if (direction == Direction.Right) {
      force.x = 1;
    } else {
      force.x = -1;
    }

    Coord memory coord;
    if (position.has(entity)) {
      coord = position.getValue(entity);
    }

    Coord memory newCoord = add(coord, force);
    Coord memory newNewCoord = add(newCoord, force);
    uint256[] memory blocks = position.getEntitiesWithValue(newCoord);

    require(blocks.length == 0 || position.getEntitiesWithValue(newNewCoord).length == 0, "Blocked");

    for (uint256 i; i < blocks.length; i++) {
      position.set(blocks[i], newNewCoord);
    }

    position.set(entity, newCoord);
  }

  function executeTyped(Direction direction) public returns (bytes memory) {
    return execute(abi.encode(direction));
  }
}
