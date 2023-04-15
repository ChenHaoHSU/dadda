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

  //wire ha1_sum, ha2_sum;
  //wire ha1_carry, ha2_carry;

  //half_adder HA1(
    //.a(a),
    //.b(b),
    //.sum(ha1_sum),
    //.carry(ha1_carry)
  //);
 
  //half_adder HA2(
    //.a(cin),
    //.b(ha1_sum),
    //.sum(ha2_sum),
    //.carry(ha2_carry)
  //);

  //assign sum = ha2_sum;
  //assign cout = ha1_carry | ha2_carry;

  wire xor_ab;
  assign xor_ab = a ^ b;
  assign sum = xor_ab ^ cin;
  assign cout = (a & b) | (cin & xor_ab);

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

module compress42_opt (
  input a,
  input b,
  input c,
  input d,
  input cin,
  output sum,
  output carry,
  output cout
);
  
  wire xor_ab;
  wire xor_cd;
  wire xor_abcd;

  assign xor_ab = a ^ b;
  assign xor_cd = c ^ d;
  assign xor_abcd = xor_ab ^ xor_cd;

  assign sum = xor_abcd ^ cin;
  assign cout = (xor_ab ? c : a);
  assign carry = (xor_abcd ? cin : d);

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

module compress52_opt (
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
  
  //wire xor_abc;
  //wire xor_decin1;

  //assign xor_abc = a ^ b ^ c;
  //assign xor_decin1 = d ^ e ^ cin1;
  //assign sum = a ^ b ^ c ^ d ^ e ^ cin1 ^ cin2;
  //assign cout1 = (a & b) | ((a | b) & c);
  //assign cout2 = ((d ^ e) ? cin1 : d);
  //assign carry = (xor_abc ^ xor_decin1) ? cin2 : xor_abc;

  wire xor_ab;
  wire xor_cd;
  wire xor_abcd;
  wire xor_ecin1;
  wire xor_abcdecin1;

  assign xor_ab = a ^ b;
  assign xor_cd = c ^ d;
  assign xor_abcd = xor_ab ^ xor_cd;
  assign xor_ecin1 = e ^ cin1;
  assign xor_abcdecin1 = xor_abcd ^ xor_ecin1;
  assign sum = xor_abcdecin1 ^ cin2;
  assign carry = xor_abcdecin1 ? cin2 : e;
  assign cout1 = xor_ab ? c : a;
  assign cout2 = xor_abcd ? cin1 : d;

endmodule

