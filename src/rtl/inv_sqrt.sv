`ifndef INV_SQRT_SV
`define INV_SQRT_SV

`include "config.svh"

module inv_sqrt(
    input logic fix_t x,
    output fix_t result
);
fix_t threehalfs; //= (1.5);
fix_t guess;

always_comb begin : inv_sqrt_i

    if      (x[30]) guess = 32'sh00000034;
    else if (x[29]) guess = 32'sh00000049;
    else if (x[28]) guess = 32'sh00000068;
    else if (x[27]) guess = 32'sh00000093;
    else if (x[26]) guess = 32'sh000000d1;
    else if (x[25]) guess = 32'sh00000127;
    else if (x[24]) guess = 32'sh000001a2;
    else if (x[23]) guess = 32'sh0000024f;
    else if (x[22]) guess = 32'sh00000344;
    else if (x[21]) guess = 32'sh0000049e;
    else if (x[20]) guess = 32'sh00000688;
    else if (x[19]) guess = 32'sh0000093c;
    else if (x[18]) guess = 32'sh00000d10;
    else if (x[17]) guess = 32'sh00001279;
    else if (x[16]) guess = 32'sh00001a20;
    else if (x[15]) guess = 32'sh000024f3;
    else if (x[14]) guess = 32'sh00003441;
    else if (x[13]) guess = 32'sh000049e6;
    else if (x[12]) guess = 32'sh00006882;
    else if (x[11]) guess = 32'sh000093cd;
    else if (x[10]) guess = 32'sh0000d105;
    else if (x[9])  guess = 32'sh0001279a;
    else if (x[8])  guess = 32'sh0001a20b;
    else if (x[7])  guess = 32'sh00024f34;
    else if (x[6])  guess = 32'sh00034417;
    else if (x[5])  guess = 32'sh00049e69;
    else if (x[4])  guess = 32'sh0006882f;
    else if (x[3])  guess = 32'sh00093cd3;
    else if (x[2])  guess = 32'sh000d105e;
    else if (x[1])  guess = 32'sh001279a7;
    else            guess = 32'sh00200000;
    // Newton's method
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    guess = mult(guess, threehalfs - mult(x >>> 1, mult(guess, guess)));
    result = guess;
end

endmodule

`endif // INV_SQRT_SV
