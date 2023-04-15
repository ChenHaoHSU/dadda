////////////////////////////////////////////
// Filename: dadda_16x16_52.v
// Synopsis: 16-by-16 Dadda multiplier
//           with 5:2 compressors
// Author: Chen-Hao Hsu
// Date: April 8, 2023
////////////////////////////////////////////

module DADDA_16x16_52(a, b, out);

  ////////////////////////////
  // Parameters
  ////////////////////////////
  parameter BIT = 16;

  ////////////////////////////
  // Input/output ports
  ////////////////////////////
  input [BIT - 1 : 0] a, b;
  output [(BIT * 2) - 1 : 0] out;
  
  ////////////////////////////
  // Wires
  ////////////////////////////
  wire [(BIT * BIT) - 1 : 0] p;
  wire [87:0] s; // sum
  wire [87:0] c; // carry
  wire [87:0] o; // cout1
  wire [87:0] t; // cout2

  ////////////////////////////
  // Dadda cores
  ////////////////////////////
  /// Level 0 (height = 16)
  genvar i, j;
  generate
    for (i = 0; i < BIT; i = i + 1) begin
      for (j = 0; j < BIT; j = j + 1) begin
        assign p[(i * BIT) + j] = (a[i] & b[j]);
      end
    end
  endgenerate

  /// Level 1 (height = 11)
  half_adder HA0 (p[11],  p[26],  s[0],   c[0]);
  full_adder FA1 (p[12],  p[27],  p[42],  s[1],   c[1]);
  half_adder HA2 (p[57],  p[72],  s[2],   c[2]);
  compress52_opt CP3 (p[13],  p[28],  p[43],  p[58],  p[73],  1'b0,  1'b0,  s[3],  c[3],  o[3],  t[3]);
  half_adder HA4 (p[88],  p[103], s[4],   c[4]);
  compress52_opt CP5 (p[14],  p[29],  p[44],  p[59],  p[74],  o[3],  t[3],  s[5],  c[5],  o[5],  t[5]);
  full_adder FA6 (p[89],  p[104], p[119], s[6],   c[6]);
  compress52_opt CP7 (p[15],  p[30],  p[45],  p[60],  p[75],  o[5],  t[5],  s[7],  c[7],  o[7],  t[7]);
  full_adder FA8 (p[90],  p[105], p[120], s[8],   c[8]);
  half_adder HA9 (p[135], p[150], s[9],   c[9]);
  compress52_opt CP10(p[31],  p[46],  p[61],  p[76],  p[91],  o[7],  t[7],  s[10], c[10], o[10], t[10]);
  full_adder FA11(p[106], p[121], p[136], s[11],  c[11]);
  half_adder HA12(p[151], p[166], s[12],  c[12]);
  compress52_opt CP13(p[47],  p[62],  p[77],  p[92],  p[107], o[10], t[10], s[13], c[13], o[13], t[13]);
  full_adder FA14(p[122], p[137], p[152], s[14],  c[14]);
  compress52_opt CP15(p[63],  p[78],  p[93],  p[108], p[123], o[13], t[13], s[15], c[15], o[15], t[15]);
  full_adder FA16(p[79],  p[94],  p[109], s[16],  c[16]);
  full_adder FA17(p[124], p[139], p[154], s[17],  c[17]);
  full_adder FA18(p[95],  p[110], p[125], s[18],  c[18]);

  /// Level 2 (height 5)
  half_adder HA19(p[5],   p[20],  s[19],  c[19]);
  compress52_opt CP20(p[6],   p[21],  p[36],  p[51],  p[66],  1'b0,  1'b0,  s[20], c[20], o[20], t[20]);
  compress52_opt CP21(p[7],   p[22],  p[37],  p[52],  p[67],  o[20], t[20], s[21], c[21], o[21], t[21]);
  compress52_opt CP22(p[8],   p[23],  p[38],  p[53],  p[68],  o[21], t[21], s[22], c[22], o[22], t[22]);
  half_adder HA23(p[83],  p[98],  s[23],  c[23]);

  compress52_opt CP24(p[9], p[24], p[39], p[54], p[69], o[22], t[22], s[24], c[24], o[24], t[24]);
  compress52_opt CP25(p[84], p[99], p[114], p[129], p[144], 1'b0, 1'b0, s[25], c[25], o[25], t[25]);
  compress52_opt CP26(p[10], p[25], p[40], p[55], p[70], o[24], t[24], s[26], c[26], o[26], t[26]);
  compress52_opt CP27(p[85], p[100], p[115], p[130], p[145], o[25], t[25], s[27], c[27], o[27], t[27]);
  compress52_opt CP28(s[0], p[41], p[56], p[71], p[86], o[26], t[26], s[28], c[28], o[28], t[28]);
  compress52_opt CP29(p[101], p[116], p[131], p[146], p[161], o[27], t[27], s[29], c[29], o[29], t[29]);
  compress52_opt CP30(s[1], c[0], s[2], p[87], p[102], o[28], t[28], s[30], c[30], o[30], t[30]);
  compress52_opt CP31(p[117], p[132], p[147], p[162], p[177], o[29], t[29], s[31], c[31], o[31], t[31]);
  compress52_opt CP32(s[3], c[1], s[4], c[2], p[118], o[30], t[30], s[32], c[32], o[32], t[32]);
  compress52_opt CP33(p[133], p[148], p[163], p[178], p[193], o[31], t[31], s[33], c[33], o[33], t[33]);
  compress52_opt CP34(s[5], c[3], s[6], c[4], p[134], o[32], t[32], s[34], c[34], o[34], t[34]);
  compress52_opt CP35(p[149], p[164], p[179], p[194], p[209], o[33], t[33], s[35], c[35], o[35], t[35]);
  compress52_opt CP36(s[7], c[5], s[8], c[6], s[9], o[34], t[34], s[36], c[36], o[36], t[36]);
  compress52_opt CP37(p[165], p[180], p[195], p[210], p[225], o[35], t[35], s[37], c[37], o[37], t[37]);
  compress52_opt CP38(s[10], c[7], s[11], c[8], s[12], o[36], t[36], s[38], c[38], o[38], t[38]);
  compress52_opt CP39(c[9], p[181], p[196], p[211], p[226], o[37], t[37], s[39], c[39], o[39], t[39]);
  compress52_opt CP40(s[13], c[10], s[14], c[11], p[167], o[38], t[38], s[40], c[40], o[40], t[40]);
  compress52_opt CP41(c[12], p[182], p[197], p[212], p[227], o[39], t[39], s[41], c[41], o[41], t[41]);
  compress52_opt CP42(s[15], c[13], p[138], c[14], p[153], o[40], t[40], s[42], c[42], o[42], t[42]);
  compress52_opt CP43(p[168], p[183], p[198], p[213], p[228], o[41], t[41], s[43], c[43], o[43], t[43]);
  compress52_opt CP44(s[16], c[15], s[17], o[15], t[15], o[42], t[42], s[44], c[44], o[44], t[44]);
  compress52_opt CP45(p[169], p[184], p[199], p[214], p[229], o[43], t[43], s[45], c[45], o[45], t[45]);
  compress52_opt CP46(s[18], c[16], p[140], c[17], p[155], o[44], t[44], s[46], c[46], o[46], t[46]);
  compress52_opt CP47(p[170], p[185], p[200], p[215], p[230], o[45], t[45], s[47], c[47], o[47], t[47]);
  compress52_opt CP48(p[111], c[18], p[126], p[141], p[156], o[46], t[46], s[48], c[48], o[48], t[48]);
  compress52_opt CP49(p[171], p[186], p[201], p[216], p[231], o[47], t[47], s[49], c[49], o[49], t[49]);
  compress52_opt CP50(p[127], p[142], p[157], p[172], p[187], o[48], t[48], s[50], c[50], o[50], t[50]);
  full_adder FA51(p[202], p[217], o[49], s[51],  c[51]);
  full_adder FA52(p[232], p[247], t[49], s[52],  c[52]);
  compress52_opt CP53(p[143], p[158], p[173], p[188], p[203], o[50], t[50], s[53], c[53], o[53], t[53]);
  full_adder FA54(p[218], p[233], p[248], s[54],  c[54]);
  compress52_opt CP55(p[159], p[174], p[189], p[204], p[219], o[53], t[53], s[55], c[55], o[55], t[55]);
  full_adder FA56(p[175], p[190], o[55], s[56],  c[56]);
  full_adder FA57(p[205], p[220], t[55], s[57],  c[57]);
  full_adder FA58(p[191], p[206], p[221], s[58],  c[58]);

  /// Level 3 (height 2)
  half_adder HA59(p[2],   p[17],  s[59],  c[59]);
  compress52_opt CP60(p[3], p[18], p[33], p[48], 1'b0, 1'b0, 1'b0, s[60], c[60], o[60], t[60]);
  compress52_opt CP61(p[4], p[19], p[34], p[49], p[64], o[60], t[60], s[61], c[61], o[61], t[61]);
  compress52_opt CP62(s[19], p[35], p[50], p[65], p[80], o[61], t[61], s[62], c[62], o[62], t[62]);
  compress52_opt CP63(s[20], c[19], p[81], p[96], 1'b0, o[62], t[62], s[63], c[63], o[63], t[63]);
  compress52_opt CP64(s[21], c[20], p[82], p[97], p[112], o[63], t[63], s[64], c[64], o[64], t[64]);
  compress52_opt CP65(s[22], c[21], s[23], p[113], p[128], o[64], t[64], s[65], c[65], o[65], t[65]);
  compress52_opt CP66(s[24], c[22], s[25], c[23], 1'b0, o[65], t[65], s[66], c[66], o[66], t[66]);
  compress52_opt CP67(s[26], c[24], s[27], c[25], p[160], o[66], t[66], s[67], c[67], o[67], t[67]);
  compress52_opt CP68(s[28], c[26], s[29], c[27], p[176], o[67], t[67], s[68], c[68], o[68], t[68]);
  compress52_opt CP69(s[30], c[28], s[31], c[29], p[192], o[68], t[68], s[69], c[69], o[69], t[69]);
  compress52_opt CP70(s[32], c[30], s[33], c[31], p[208], o[69], t[69], s[70], c[70], o[70], t[70]);
  compress52_opt CP71(s[34], c[32], s[35], c[33], p[224], o[70], t[70], s[71], c[71], o[71], t[71]);
  compress52_opt CP72(s[36], c[34], s[37], c[35], p[240], o[71], t[71], s[72], c[72], o[72], t[72]);
  compress52_opt CP73(s[38], c[36], s[39], c[37], p[241], o[72], t[72], s[73], c[73], o[73], t[73]);
  compress52_opt CP74(s[40], c[38], s[41], c[39], p[242], o[73], t[73], s[74], c[74], o[74], t[74]);
  compress52_opt CP75(s[42], c[40], s[43], c[41], p[243], o[74], t[74], s[75], c[75], o[75], t[75]);
  compress52_opt CP76(s[44], c[42], s[45], c[43], p[244], o[75], t[75], s[76], c[76], o[76], t[76]);
  compress52_opt CP77(s[46], c[44], s[47], c[45], p[245], o[76], t[76], s[77], c[77], o[77], t[77]);
  compress52_opt CP78(s[48], c[46], s[49], c[47], p[246], o[77], t[77], s[78], c[78], o[78], t[78]);
  compress52_opt CP79(s[50], c[48], s[51], c[49], s[52], o[78], t[78], s[79], c[79], o[79], t[79]);
  compress52_opt CP80(s[53], c[50], s[54], c[51], c[52], o[79], t[79], s[80], c[80], o[80], t[80]);
  compress52_opt CP81(s[55], c[53], p[234], c[54], p[249], o[80], t[80], s[81], c[81], o[81], t[81]);
  compress52_opt CP82(s[56], c[55], s[57], p[235], p[250], o[81], t[81], s[82], c[82], o[82], t[82]);
  compress52_opt CP83(s[58], c[56], p[236], c[57], p[251], o[82], t[82], s[83], c[83], o[83], t[83]);
  compress52_opt CP84(p[207], c[58], p[222], p[237], p[252], o[83], t[83], s[84], c[84], o[84], t[84]);
  compress52_opt CP85(p[223], p[238], p[253], 1'b0, 1'b0, o[84], t[84], s[85], c[85], o[85], t[85]);
  compress52_opt CP86(p[239], p[254], 1'b0, 1'b0, 1'b0, o[85], t[85], s[86], c[86], o[86], t[86]);
  full_adder FA87(p[255], o[86], t[86], s[87], c[87]);

  /// Carry propogation adder (CPA)
  wire [30:0] cpa_a; 
  wire [30:0] cpa_b; 
  wire [31:0] cpa_sum; 

  assign cpa_a = {1'b0, s[87:59], p[1]}; 
  assign cpa_b = {c[87:59], p[32], p[16]};
  assign cpa_sum = cpa_a + cpa_b;

  /// assign result to output
  assign out[0] = p[0];
  assign out[31:1] = cpa_sum[30:0];

endmodule
