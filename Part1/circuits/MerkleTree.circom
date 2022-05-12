pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves

    // root element;
    if (n == 0) {
        root <== leaves[0];
    }
    component poseidon = Poseidon(2);
    component nextLevel = CheckRoot(n-1);
    for (var i = 0; i < 2**n / 2; i++) {
        poseidon.inputs[0] <== leaves[2*n];
        if (!leaves[(2*n)+1]) {
            poseidon.inputs[1] <== leaves[2*n];
        } else {
            poseidon.inputs[1] <== leaves[(2*n)+1];
        }
        checkRoot.leaves[i] <== poseidon.out;
    }
    root <== checkRoot.root;
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
    component poseidon = Poseidon(2);
    var hash = leaf;
    for (var i = 0; i < n; i++) {
        if (path_index == 0) {
            poseidon.inputs[0] <== hash; 
            poseidon.inputs[1] <== path_elements[i];
            hash <== poseidon.out;
        } else {
            poseidon.inputs[0] <== path_elements[i];
            poseidon.inputs[1] <== hash;
            hash <== poseidon.out;
        }

    }
}