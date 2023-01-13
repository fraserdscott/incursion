// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById } from "solecs/utils.sol";

import { ColorComponent, ID as ColorComponentID } from "../components/ColorComponent.sol";
import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.Create"));
uint256 constant NUM_COLORS = 8;

contract CreateSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    ColorComponent color = ColorComponent(getAddressById(components, ColorComponentID));
    PositionComponent position = PositionComponent(getAddressById(components, PositionComponentID));

    for (uint256 i; i < NUM_COLORS; i++) {
      for (uint256 j; j < NUM_COLORS; j++) {
        uint256 index = i + j * NUM_COLORS;

        color.set(index, uint32(i));
        position.set(index, Coord(int32(uint32((i * 3) + 2)), int32(uint32(j + 2))));
      }
    }
  }
}
