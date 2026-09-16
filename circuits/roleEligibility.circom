pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

// Proves "my role is in the allowed list" WITHOUT revealing which role.
template RoleEligibility(n) {
    signal input role;              // PRIVATE - never revealed
    signal input allowedRoles[n];   // PUBLIC
    signal output isValid;          // PUBLIC - 1 if allowed, 0 if not

    component eq[n];
    signal partialSum[n + 1];
    partialSum[0] <== 0;

    for (var i = 0; i < n; i++) {
        eq[i] = IsEqual();
        eq[i].in[0] <== role;
        eq[i].in[1] <== allowedRoles[i];
        partialSum[i + 1] <== partialSum[i] + eq[i].out;
    }

    component isZero = IsZero();
    isZero.in <== partialSum[n];
    isValid <== 1 - isZero.out;
}

component main {public [allowedRoles]} = RoleEligibility(4);