pragma circom 2.0.0;

template Sha256(n) {
    signal input inputs[n];
    signal output outputs[2];

    // Dummy-Hash zur Demo – ersetzt keine echte SHA256-Funktion
    for (var i = 0; i < 2; i++) {
        outputs[i] <== inputs[i % n] * 1234567;
    }
}
