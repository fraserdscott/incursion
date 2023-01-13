import { tileCoordToPixelCoord } from "@latticexyz/phaserx";
import { defineComponentSystem, getComponentValue, getComponentValueStrict } from "@latticexyz/recs";
import { NetworkLayer } from "../../network";
import { Sprites } from "../constants";
import { PhaserLayer } from "../types";

export function createPositionSystem(network: NetworkLayer, phaser: PhaserLayer) {
  const {
    world,
    components: { Color, Position },
  } = network;

  const {
    scenes: {
      Main: {
        objectPool,
        config,
        maps: {
          Main: { tileWidth, tileHeight },
        },
      },
    },
  } = phaser;

  defineComponentSystem(world, Position, (update) => {
    const position = update.value[0];
    if (!position) return console.warn("no position");

    const object = objectPool.get(update.entity, "Sprite");
    const { x, y } = tileCoordToPixelCoord(position, tileWidth, tileHeight);

    const color = getComponentValue(Color, update.entity);

    if (color) {
      const sprite = config.sprites[Sprites.Gold];

      object.setComponent({
        id: Position.id,
        once: (gameObject) => {
          gameObject.setTexture(sprite.assetKey, sprite.frame);
          gameObject.setPosition(x, y);

          if (color) {
            gameObject.setTint(((color.value + 1) * 16777216) / (8 + 1));
          }
        },
      });
    } else {
      {
        const sprite = config.sprites[Sprites.Donkey];

        object.setComponent({
          id: Position.id,
          once: (gameObject) => {
            gameObject.setTexture(sprite.assetKey, sprite.frame);
            gameObject.setPosition(x, y);
          },
        });
      }
    }
  });
}
