////////////////////////////////////////////
// Filename: dadda8.v
// Synopsis: 8-by-8 Dadda multiplier
// Author: Chen-Hao Hsu
// Date: Mar 30, 2023
////////////////////////////////////////////

module DADDA_8x8(a, b, out);

  ////////////////////////////
  // Parameters
  ////////////////////////////
  parameter BIT = 8;

  ////////////////////////////
  // Input/output ports
  ////////////////////////////
  input [BIT - 1 : 0] a, b;
  output [(BIT * 2) - 1 : 0] out;
  
  ////////////////////////////
  // Wires
  ////////////////////////////
  wire [(BIT * BIT) - 1 : 0] p;
  wire [41:0] s;
  wire [41:0] c;

  ////////////////////////////
  // Dadda cores
  ////////////////////////////
  /// Level 0 (height = 8)
  genvar i, j;
  generate
    for (i = 0; i < BIT; i = i + 1) begin
      for (j = 0; j < BIT; j = j + 1) begin
        assign p[(i * BIT) + j] = (a[i] & b[j]);
      end
    end
  endgenerate

  /// Level 1 (height = 6)
  half_adder HA0(p[6],  p[13],        s[0], c[0]);
  full_adder FA1(p[7],  p[14], p[21], s[1], c[1]);
  half_adder HA2(p[28], p[35],        s[2], c[2]);
  full_adder FA3(p[15], p[22], p[29], s[3], c[3]);
  half_adder HA4(p[36], p[43],        s[4], c[4]);
  full_adder FA5(p[23], p[30], p[37], s[5], c[5]);

  /// Level 2 (height = 4)
  half_adder HA6(p[4],  p[11],        s[6], c[6]);
  full_adder FA7(p[5],  p[12], p[19], s[7], c[7]);
  half_adder HA8(p[26], p[33],        s[8], c[8]);
  full_adder FA9(s[0],  p[20], p[27], s[9], c[9]);
  full_adder FA10(p[34], p[41], p[48], s[10], c[10]);
  full_adder FA11(c[0],  s[1],  s[2],  s[11], c[11]);
  full_adder FA12(p[42], p[49], p[56], s[12], c[12]);
  full_adder FA13(c[1],  c[2],  s[3],  s[13], c[13]);
  full_adder FA14(s[4],  p[50], p[57], s[14], c[14]);
  full_adder FA15(c[3],  c[4],  s[5],  s[15], c[15]);
  full_adder FA16(p[44], p[51], p[58], s[16], c[16]);
  full_adder FA17(c[5],  p[31], p[38], s[17], c[17]);
  full_adder FA18(p[45], p[52], p[59], s[18], c[18]);
  full_adder FA19(p[39], p[46], p[53], s[19], c[19]);
  
  /// Level 3 (height = 3)
  half_adder HA20(p[3],  p[10],        s[20], c[20]);
  full_adder FA21(s[6],  p[18], p[25], s[21], c[21]);
  full_adder FA22(c[6],  s[7],  s[8],  s[22], c[22]);
  full_adder FA23(c[7],  c[8],  s[9],  s[23], c[23]);
  full_adder FA24(c[9],  c[10], s[11], s[24], c[24]);
  full_adder FA25(c[11], c[12], s[13], s[25], c[25]);
  full_adder FA26(c[13], c[14], s[15], s[26], c[26]);
  full_adder FA27(c[15], c[16], s[17], s[27], c[27]);
  full_adder FA28(c[17], c[18], s[19], s[28], c[28]);
  full_adder FA29(c[19], p[47], p[54], s[29], c[29]);

  /// Level 4 (height = 2)
  half_adder HA30(p[2],  p[9],         s[30], c[30]);
  full_adder FA31(s[20], p[17], p[24], s[31], c[31]);
  full_adder FA32(c[20], s[21], p[32], s[32], c[32]);
  full_adder FA33(c[21], s[22], p[40], s[33], c[33]);
  full_adder FA34(c[22], s[23], s[10], s[34], c[34]);
  full_adder FA35(c[23], s[24], s[12], s[35], c[35]);
  full_adder FA36(c[24], s[25], s[14], s[36], c[36]);
  full_adder FA37(c[25], s[26], s[16], s[37], c[37]);
  full_adder FA38(c[26], s[27], s[18], s[38], c[38]);
  full_adder FA39(c[27], s[28], p[60], s[39], c[39]);
  full_adder FA40(c[28], s[29], p[61], s[40], c[40]);
  full_adder FA41(c[29], p[55], p[62], s[41], c[41]);

  /// Carry propogation adder (CPA)
  wire [13:0] cpa_a; 
  wire [13:0] cpa_b; 
  wire [14:0] cpa_sum; 

  assign cpa_a = {c[41:30], s[30], p[1]}; 
  assign cpa_b = {p[63], s[41:31], p[16], p[8]};
  assign cpa_sum = cpa_a + cpa_b;

  /// assign result to output
  assign out[0] = p[0];
  assign out[15:1] = cpa_sum[14:0];

endmodule

