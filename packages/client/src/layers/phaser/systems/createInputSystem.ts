import { pixelCoordToTileCoord } from "@latticexyz/phaserx";
import { NetworkLayer } from "../../network";
import { PhaserLayer } from "../types";

export function createInputSystem(network: NetworkLayer, phaser: PhaserLayer) {
  const {
    world,
    scenes: {
      Main: { input },
    },
  } = phaser;

  const keySub = input.keyboard$.subscribe((p) => {
    if (p.isUp) {
      if (p.originalEvent.key === "w") {
        network.api.move(1);
      } else if (p.originalEvent.key === "s") {
        network.api.move(0);
      } else if (p.originalEvent.key === "a") {
        network.api.move(2);
      } else if (p.originalEvent.key === "d") {
        network.api.move(3);
      } else if (p.originalEvent.key === "c") {
        network.api.create();
      }
    }
  });

  world.registerDisposer(() => keySub?.unsubscribe());
}
