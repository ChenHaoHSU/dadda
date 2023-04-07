////////////////////////////////////////////
// Filename: adder.v
// Synopsis: half adder, full adder,
//           4:2 compressor,
//           5:2 compressor
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

////////////////////////////
// 4:2 Compressor
////////////////////////////
module compress42 (
  input a,
  input b,
  input c,
  input d,
  input cin,
  output sum,
  output carry,
  output cout
);
  
  wire fa1_sum;

  full_adder FA1(
    .a(a),
    .b(b),
    .cin(c),
    .sum(fa1_sum),
    .cout(cout)
  );
  
  full_adder FA2(
    .a(fa1_sum),
    .b(d),
    .cin(cin),
    .sum(sum),
    .cout(carry)
  );

endmodule

////////////////////////////
// 5:2 Compressor
////////////////////////////
module compress52 (
  input a,
  input b,
  input c,
  input d,
  input e,
  input cin1,
  input cin2,
  output sum,
  output carry,
  output cout1,
  output cout2
);
  
  wire fa1_sum;
  wire fa2_sum;

  full_adder FA1(
    .a(a),
    .b(b),
    .cin(c),
    .sum(fa1_sum),
    .cout(cout1)
  );
  
  full_adder FA2(
    .a(fa1_sum),
    .b(d),
    .cin(cin1),
    .sum(fa2_sum),
    .cout(cout2)
  );
  
  full_adder FA3(
    .a(fa2_sum),
    .b(e),
    .cin(cin2),
    .sum(sum),
    .cout(carry)
  );

endmodule

