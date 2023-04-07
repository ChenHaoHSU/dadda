////////////////////////////////////////////
// Filename: dadda_8x8_42.v
// Synopsis: 8-by-8 Dadda multiplier
//           with 4:2 compressors
// Author: Chen-Hao Hsu
// Date: Apr 6, 2023
////////////////////////////////////////////

module DADDA_8x8_42(a, b, out);

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
  wire [41:0] s; // sum
  wire [41:0] c; // carry
  wire [41:0] o; // cout

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

  /// Level 1 (height = 4)
  half_adder HA0(p[4],  p[11], s[0],  c[0]);
  compress42 CP1(p[5],  p[12], p[19], p[26], c[0], s[1], c[1], o[1]);
  compress42 CP2(p[6],  p[13], p[20], p[27], o[1], s[2], c[2], o[2]);
  half_adder HA3(p[34], p[41], s[3],  c[3]);
  compress42 CP4(p[7],  p[14], p[21], p[28], o[2], s[4], c[4], o[4]);
  compress42 CP5(p[35], p[42], p[49], p[56], c[3], s[5], c[5], o[5]);
  compress42 CP6(p[15], p[22], p[29], p[36], o[4], s[6], c[6], o[6]);
  compress42 CP7(p[43], p[50], p[57], 1'b0,  o[5], s[7], c[7], o[7]);
  compress42 CP8(p[23], p[30], p[37], p[44], o[6], s[8], c[8], o[8]);
  full_adder FA9(p[51], p[58], o[7],  s[9],  c[9]);
  compress42 CP10(p[31], p[38], p[45], p[52], o[8], s[10], c[10], o[10]);
  full_adder FA11(p[39], p[46], o[10], s[11], c[11]);

  /// Level 2 (height = 2)
  half_adder HA12(p[2],  p[9],  s[12], c[12]);
  compress42 CP13(p[3],  p[10], p[17], p[24], c[12], s[13], c[13], o[13]);
  compress42 CP14(s[0],  p[18], p[25], p[32], o[13], s[14], c[14], o[14]);
  compress42 CP15(s[1],  p[33], p[40], 1'b0,  o[14], s[15], c[15], o[15]);
  compress42 CP16(s[2],  c[1],  s[3],  p[48], o[15], s[16], c[16], o[16]);
  compress42 CP17(s[4],  c[2],  s[5],  1'b0,  o[16], s[17], c[17], o[17]);
  compress42 CP18(s[6],  c[4],  s[7],  c[5],  o[17], s[18], c[18], o[18]);
  compress42 CP19(s[8],  c[6],  s[9],  c[7],  o[18], s[19], c[19], o[19]);
  compress42 CP20(s[10], c[8],  p[59], c[9],  o[19], s[20], c[20], o[20]);
  compress42 CP21(s[11], c[10], p[53], p[60], o[20], s[21], c[21], o[21]);
  compress42 CP22(p[47], c[11], p[54], p[61], o[21], s[22], c[22], o[22]);
  full_adder FA23(p[55], p[62], o[22], s[23], c[23]);

  /// Carry propogation adder (CPA)
  wire [13:0] cpa_a; 
  wire [13:0] cpa_b; 
  wire [14:0] cpa_sum; 

  assign cpa_a = {p[63], s[23:12] , p[1]}; 
  assign cpa_b = {c[23:13], 1'b0, p[16], p[8]};
  assign cpa_sum = cpa_a + cpa_b;

  /// assign result to output
  assign out[0] = p[0];
  assign out[15:1] = cpa_sum[14:0];

endmodule
