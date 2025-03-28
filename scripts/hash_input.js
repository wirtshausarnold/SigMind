const crypto = require("crypto");

// Simuliere dieselben msg+salt wie in input.json
const msg = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
const salt = [1234, 5678];

// 1. Kombiniere alle Zahlen in ein Buffer
const all = msg.concat(salt);
const buf = Buffer.alloc(all.length * 4);
all.forEach((num, i) => buf.writeUInt32BE(num, i * 4));

// 2. SHA256 Hash
const hash = crypto.createHash("sha256").update(buf).digest();

// 3. In zwei 128-Bit-Felder splitten
const part1 = hash.slice(0, 16).readBigUInt64BE(8);  // zweite Hälfte der ersten 128 Bit
const part2 = hash.slice(16).readBigUInt64BE(8);     // zweite Hälfte der zweiten 128 Bit

console.log("pubHash für input.json:");
console.log([Number(part1), Number(part2)]);
