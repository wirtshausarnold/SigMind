pragma circom 2.0.0;

include "circomlib/circuits/sha256/sha256.circom";
include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/bitify.circom";

// SigMind Circuit: Verifies that the hash of msg + salt is correct

template SigMindHash(n) {
    signal input msg[n];          // Eingabe-Nachricht (z. B. KI-Content als Felder)
    signal input salt[2];         // Privates Salt
    signal input pubHash[2];      // Öffentlicher Vergleichs-Hash
    signal output isValid;        // 1 = Hash stimmt

    signal inputFields[n + 2];
    for (var i = 0; i < n; i++) {
        inputFields[i] <== msg[i];
    }
    inputFields[n] <== salt[0];
    inputFields[n + 1] <== salt[1];

    component toBits[n + 2];
    var totalBits = 0;
    for (var i = 0; i < n + 2; i++) {
        toBits[i] = Num2Bits(32);  // 32 Bit pro Feld – SHA256 erwartet 512 Bits
        toBits[i].in <== inputFields[i];
        totalBits += 32;
    }

    signal inputBits[totalBits];
    var bitIndex = 0;
    for (var i = 0; i < n + 2; i++) {
        for (var j = 0; j < 32; j++) {
            inputBits[bitIndex] <== toBits[i].out[j];
            bitIndex++;
        }
    }

    component hasher = Sha256(512);
    hasher.in <== inputBits;

    component outBits0 = Bits2Num(128);
    component outBits1 = Bits2Num(128);

    for (var i = 0; i < 128; i++) {
        outBits0.in[i] <== hasher.out[i];
        outBits1.in[i] <== hasher.out[i + 128];
    }

    component eq[2];
    eq[0] = IsEqual(); eq[1] = IsEqual();

    eq[0].in[0] <== outBits0.out;
    eq[0].in[1] <== pubHash[0];

    eq[1].in[0] <== outBits1.out;
    eq[1].in[1] <== pubHash[1];

    isValid <== eq[0].out * eq[1].out;
}

// Main component mit 14 Feldern → ergibt zusammen mit 2 Salt-Feldern genau 512 Bit
component main = SigMindHash(14);
