pragma circom 2.0.0;

include "sha256.circom";

template MessageHash() {
    signal input msg[4];
    signal output hash[2];

    component hasher = Sha256(4);
    for (var i = 0; i < 4; i++) {
        hasher.inputs[i] <== msg[i];
    }

    for (var i = 0; i < 2; i++) {
        hash[i] <== hasher.outputs[i];
    }
}

component main = MessageHash();
