const fs = require("fs");
const snarkjs = require("snarkjs");

async function generateProof() {
  const input = JSON.parse(fs.readFileSync("input.json"));

  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    input,
    "proof_js/proof.wasm",
    "proof.zkey"
  );

  fs.writeFileSync("proof.json", JSON.stringify(proof, null, 2));
  fs.writeFileSync("public.json", JSON.stringify(publicSignals, null, 2));

  const vKey = JSON.parse(fs.readFileSync("verification_key.json"));
  const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

  if (res === true) {
    console.log("✅ SigMind Proof verified successfully");
  } else {
    console.error("❌ SigMind Proof invalid");
  }
}

generateProof();
