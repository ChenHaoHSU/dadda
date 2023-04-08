////////////////////////////////////////////
// Filename: dadda_8x8_52.v
// Synopsis: 8-by-8 Dadda multiplier
//           with 5:2 compressors
// Author: Chen-Hao Hsu
// Date: Apr 6, 2023
////////////////////////////////////////////

module DADDA_8x8_52(a, b, out);

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
  wire [21:0] s; // sum
  wire [21:0] c; // carry
  wire [21:0] o; // cout1
  wire [21:0] t; // cout2

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

  /// Level 1 (height = 5)
  half_adder HA0(p[5],  p[12], s[0],  c[0]);
  full_adder FA1(p[6],  p[13], p[20], s[1],  c[1]);
  half_adder HA2(p[27], p[34], s[2],  c[2]);
  compress52 CP3(p[7],  p[14], p[21], p[28], p[35], 1'b0, 1'b0, s[3], c[3], o[3], t[3]);
  half_adder HA4(p[42], p[49], s[4],  c[4]);
  compress52 CP5(p[15], p[22], p[29], p[36], p[43], o[3], t[3], s[5], c[5], o[5], t[5]);
  full_adder FA6(p[23], p[30], p[37], s[6],  c[6]);
  full_adder FA7(p[44], p[51], p[58], s[7],  c[7]);
  full_adder FA8(p[31], p[38], p[45], s[8],  c[8]);

  /// Level 2 (height = 2)
  half_adder HA9(p[2],  p[9], s[9],  c[9]);
  compress52 CP10(p[3],  p[10], p[17], p[24], 1'b0,  1'b0,  1'b0, s[10], c[10], o[10], t[10]);
  compress52 CP11(p[4],  p[11], p[18], p[25], p[32], o[10], t[10], s[11], c[11], o[11], t[11]);
  compress52 CP12(s[0],  p[19], p[26], p[33], p[40], o[11], t[11], s[12], c[12], o[12], t[12]);
  compress52 CP13(s[1],  c[0],  s[2],  p[41], p[48], o[12], t[12], s[13], c[13], o[13], t[13]);
  compress52 CP14(s[3],  c[1],  s[4],  c[2],  p[56], o[13], t[13], s[14], c[14], o[14], t[14]);
  compress52 CP15(s[5],  c[3],  p[50], c[4],  p[57], o[14], t[14], s[15], c[15], o[15], t[15]);

  compress52 CP16(s[6],  c[5],  s[7],  o[5],  t[5],  o[15], t[15], s[16], c[16], o[16], t[16]);
  compress52 CP17(s[8],  c[6],  p[52], c[7],  p[59], o[16], t[16], s[17], c[17], o[17], t[17]);
  compress52 CP18(p[39], c[8],  p[46], p[53], p[60], o[17], t[17], s[18], c[18], o[18], t[18]);
  compress52 CP19(p[47], p[54], p[61], 1'b0,  1'b0,  o[18], t[18], s[19], c[19], o[19], t[19]);
  compress52 CP20(p[55], p[62], 1'b0,  1'b0,  1'b0,  o[19], t[19], s[20], c[20], o[20], t[20]);
  full_adder FA21(p[63], o[20], t[20], s[21], c[21]);

  /// Carry propogation adder (CPA)
  wire [14:0] cpa_a; 
  wire [14:0] cpa_b; 
  wire [15:0] cpa_sum; 

  assign cpa_a = {1'b0, s[21:9], p[1]}; 
  assign cpa_b = {c[21:9], p[16], p[8]};
  assign cpa_sum = cpa_a + cpa_b;

  /// assign result to output
  assign out[0] = p[0];
  assign out[15:1] = cpa_sum[14:0];

endmodule


module DADDA_8x8_52_OLD(a, b, out);

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
  wire [17:0] s; // sum
  wire [17:0] c; // carry
  wire [17:0] o; // cout1
  wire [17:0] t; // cout2

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

  /// Level 1 (height = 5)
  half_adder HA0(p[5],  p[12], s[0],  c[0]);
  compress42 CP1(p[6],  p[13], p[20], p[27], 1'b0,  s[1], c[1], o[1]);
  compress52 CP2(p[7],  p[14], p[21], p[28], p[35], o[1], 1'b0, s[2], c[2], o[2], t[2]);
  compress52 CP3(p[15], p[22], p[29], p[36], p[43], o[2], t[2], s[3], c[3], o[3], t[3]);
  compress42 CP4(p[23], p[30], p[37], o[3],  t[3],  s[4], c[4], o[4]);
  full_adder FA5(p[31], p[38], o[4],  s[5],  c[5]);

  /// Level 2 (height = 2)
  half_adder HA6(p[2],  p[9],  s[6],  c[6]);
  compress42 CP7(p[3],  p[10], p[17], p[24], 1'b0,  s[7],  c[7], o[7]);
  compress52 CP8(p[4],  p[11], p[18], p[25], p[32], o[7], 1'b0, s[8], c[8], o[8], t[8]);
  compress52 CP9(s[0],  p[19], p[26], p[33], p[40], o[8], t[8], s[9], c[9], o[9], t[9]);
  compress52 CP10(s[1],  c[0],  p[34], p[41], p[48], o[9],  t[9],  s[10], c[10], o[10], t[10]);
  compress52 CP11(s[2],  c[1],  p[42], p[49], p[56], o[10], t[10], s[11], c[11], o[11], t[11]);
  compress52 CP12(s[3],  c[2],  p[50], p[57], 1'b0,  o[11], t[11], s[12], c[12], o[12], t[12]);
  compress52 CP13(s[4],  c[3],  p[44], p[51], p[58], o[12], t[12], s[13], c[13], o[13], t[13]);
  compress52 CP14(s[5],  c[4],  p[45], p[52], p[59], o[13], t[13], s[14], c[14], o[14], t[14]);
  compress52 CP15(p[39], c[5],  p[46], p[53], p[60], o[14], t[14], s[15], c[15], o[15], t[15]);
  compress42 CP16(p[47], p[54], p[61], o[15], t[15], s[16], c[16], o[16]);
  full_adder FA17(p[55], p[62], o[16], s[17], c[17]);

  /// Carry propogation adder (CPA)
  wire [13:0] cpa_a; 
  wire [13:0] cpa_b; 
  wire [14:0] cpa_sum; 

  assign cpa_a = {p[63], s[17:6], p[1]}; 
  assign cpa_b = {c[17:6], p[16], p[8]};
  assign cpa_sum = cpa_a + cpa_b;

  /// assign result to output
  assign out[0] = p[0];
  assign out[15:1] = cpa_sum[14:0];

endmodule
