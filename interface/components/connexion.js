import { principal } from "../stores";
import { daoActor } from "../stores";
import { idlFactory as idlFactoryDAO } from "../../src/declarations/dao/dao.did.js";

//TODO : Add your mainnet id whenever you have deployed on the IC
const daoCanisterId =
  process.env.NODE_ENV === "development"
    ? "ryjl3-tyaaa-aaaaa-aaaba-cai"
    : "bnmyt-3iaaa-aaaal-qbsja-cai";

// See https://docs.plugwallet.ooo/ for more informations
export async function plugConnection() {
  const result = await window.ic.plug.requestConnect({
    whitelist: [daoCanisterId],
  });

  const p = window.ic.plug.agent.getPrincipal();
  const actor = await window.ic.plug.createActor({
    canisterId: daoCanisterId,
    interfaceFactory: idlFactoryDAO,
  });

  principal.update(() => p);
  daoActor.update(() => actor);
}
