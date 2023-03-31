////////////////////////////////////////////
// Filename: adder.v
// Synopsis: half adder, full adder
// Author: Chen-Hao Hsu
// Date: Mar 30, 2023
////////////////////////////////////////////

////////////////////////////
// Half Adder
////////////////////////////
module half_adder (
  input a,
  input b,
  output sum,
  output carry
);

  assign sum = a ^ b;
  assign carry = a & b; 

endmodule

////////////////////////////
// Full Adder
////////////////////////////
module full_adder (
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  wire ha1_sum, ha2_sum;
  wire ha1_carry, ha2_carry;

  half_adder HA1(
    .a(a),
    .b(b),
    .sum(ha1_sum),
    .carry(ha1_carry)
  );
 
  half_adder HA2(
    .a(cin),
    .b(ha1_sum),
    .sum(ha2_sum),
    .carry(ha2_carry)
  );

  assign sum = ha2_sum;
  assign cout = ha1_carry | ha2_carry;

endmodule


