////////////////////////////////////////////
// Filename: dadda_16x16_42.v
// Synopsis: 16-by-16 Dadda multiplier
//           with 4:2 compressors
// Author: Chen-Hao Hsu
// Date: April 7, 2023
////////////////////////////////////////////

module DADDA_16x16_42(a, b, out);
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
  wire [111:0] s; // sum
  wire [111:0] c; // carry
  wire [111:0] o; // cout

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

  /// Level 1 (height = 8)
  half_adder HA0 (p[8],   p[23],  s[0],   c[0]);
  compress42 CP1 (p[9],   p[24],  p[39],  p[54],  1'b0,  s[1],  c[1],  o[1]);
  compress42 CP2 (p[10],  p[25],  p[40],  p[55],  o[1],  s[2],  c[2],  o[2]);
  half_adder HA3 (p[70],  p[85],  s[3],   c[3]);
  compress42 CP4 (p[11],  p[26],  p[41],  p[56],  o[2],  s[4],  c[4],  o[4]);
  compress42 CP5 (p[71],  p[86],  p[101], p[116], 1'b0,  s[5],  c[5],  o[5]);
  compress42 CP6 (p[12],  p[27],  p[42],  p[57],  o[4],  s[6],  c[6],  o[6]);
  compress42 CP7 (p[72],  p[87],  p[102], p[117], o[5],  s[7],  c[7],  o[7]);
  half_adder HA8 (p[132], p[147], s[8],   c[8]);
  compress42 CP9 (p[13],  p[28],  p[43],  p[58],  o[6],  s[9],  c[9],  o[9]);
  compress42 CP10(p[73],  p[88],  p[103], p[118], o[7],  s[10], c[10], o[10]);
  compress42 CP11(p[133], p[148], p[163], p[178], 1'b0,  s[11], c[11], o[11]);
  compress42 CP12(p[14],  p[29],  p[44],  p[59],  o[9],  s[12], c[12], o[12]);
  compress42 CP13(p[74],  p[89],  p[104], p[119], o[10], s[13], c[13], o[13]);
  compress42 CP14(p[134], p[149], p[164], p[179], o[11], s[14], c[14], o[14]);
  half_adder HA15(p[194], p[209], s[15],  c[15]);
  compress42 CP16(p[15],  p[30],  p[45],  p[60],  o[12], s[16], c[16], o[16]);
  compress42 CP17(p[75],  p[90],  p[105], p[120], o[13], s[17], c[17], o[17]);
  compress42 CP18(p[135], p[150], p[165], p[180], o[14], s[18], c[18], o[18]);
  compress42 CP19(p[195], p[210], p[225], p[240], 1'b0,  s[19], c[19], o[19]);
  compress42 CP20(p[31],  p[46],  p[61],  p[76],  o[16], s[20], c[20], o[20]);
  compress42 CP21(p[91],  p[106], p[121], p[136], o[17], s[21], c[21], o[21]);
  compress42 CP22(p[151], p[166], p[181], p[196], o[18], s[22], c[22], o[22]);
  compress42 CP23(p[211], p[226], p[241], 1'b0,   o[19], s[23], c[23], o[23]);
  compress42 CP24(p[47],  p[62],  p[77],  p[92],  o[20], s[24], c[24], o[24]);
  compress42 CP25(p[107], p[122], p[137], p[152], o[21], s[25], c[25], o[25]);
  compress42 CP26(p[167], p[182], p[197], p[212], o[22], s[26], c[26], o[26]);
  full_adder FA27(p[227], p[242], o[23],  s[27],  c[27]);
  compress42 CP28(p[63],  p[78],  p[93],  p[108], o[24], s[28], c[28], o[28]);
  compress42 CP29(p[123], p[138], p[153], p[168], o[25], s[29], c[29], o[29]);
  compress42 CP30(p[183], p[198], p[213], p[228], o[26], s[30], c[30], o[30]);
  compress42 CP31(p[79],  p[94],  p[109], p[124], o[28], s[31], c[31], o[31]);
  compress42 CP32(p[139], p[154], p[169], p[184], o[29], s[32], c[32], o[32]);
  full_adder FA33(p[199], p[214], o[30],  s[33],  c[33]);
  compress42 CP34(p[95],  p[110], p[125], p[140], o[31], s[34], c[34], o[34]);
  compress42 CP35(p[155], p[170], p[185], p[200], o[32], s[35], c[35], o[35]);
  compress42 CP36(p[111], p[126], p[141], p[156], o[34], s[36], c[36], o[36]);
  full_adder FA37(p[171], p[186], o[35],  s[37],  c[37]);
  compress42 CP38(p[127], p[142], p[157], p[172], o[36], s[38], c[38], o[38]);
  full_adder FA39(p[143], p[158], o[38],  s[39],  c[39]);

  /// Level 2 (height 4)
  half_adder HA40(p[4],   p[19],  s[40],  c[40]);
  compress42 CP41(p[5],   p[20],  p[35],  p[50],  1'b0,  s[41], c[41], o[41]);
  compress42 CP42(p[6],   p[21],  p[36],  p[51],  o[41], s[42], c[42], o[42]);
  half_adder HA43(p[66],  p[81],  s[43],  c[43]);
  compress42 CP44(p[7],   p[22],  p[37],  p[52],  o[42], s[44], c[44], o[44]);
  compress42 CP45(p[67],  p[82],  p[97],  p[112], 1'b0,  s[45], c[45], o[45]);
  compress42 CP46(s[0],   p[38],  p[53],  p[68],  o[44], s[46], c[46], o[46]);
  compress42 CP47(p[83],  p[98],  p[113], p[128], o[45], s[47], c[47], o[47]);
  compress42 CP48(s[1],   c[0],   p[69],  p[84],  o[46], s[48], c[48], o[48]);
  compress42 CP49(p[99],  p[114], p[129], p[144], o[47], s[49], c[49], o[49]);
  compress42 CP50(s[2],   c[1],   s[3],   p[100], o[48], s[50], c[50], o[50]);
  compress42 CP51(p[115], p[130], p[145], p[160], o[49], s[51], c[51], o[51]);
  compress42 CP52(s[4],   c[2],   s[5],   c[3],   o[50], s[52], c[52], o[52]);
  compress42 CP53(p[131], p[146], p[161], p[176], o[51], s[53], c[53], o[53]);
  compress42 CP54(s[6],   c[4],   s[7],   c[5],   o[52], s[54], c[54], o[54]);
  compress42 CP55(s[8],   p[162], p[177], p[192], o[53], s[55], c[55], o[55]);
  compress42 CP56(s[9],   c[6],   s[10],  c[7],   o[54], s[56], c[56], o[56]);
  compress42 CP57(s[11],  c[8],   p[193], p[208], o[55], s[57], c[57], o[57]);
  compress42 CP58(s[12],  c[9],   s[13],  c[10],  o[56], s[58], c[58], o[58]);
  compress42 CP59(s[14],  c[11],  s[15],  p[224], o[57], s[59], c[59], o[59]);
  compress42 CP60(s[16],  c[12],  s[17],  c[13],  o[58], s[60], c[60], o[60]);
  compress42 CP61(s[18],  c[14],  s[19],  c[15],  o[59], s[61], c[61], o[61]);
  compress42 CP62(s[20],  c[16],  s[21],  c[17],  o[60], s[62], c[62], o[62]);
  compress42 CP63(s[22],  c[18],  s[23],  c[19],  o[61], s[63], c[63], o[63]);
  compress42 CP64(s[24],  c[20],  s[25],  c[21],  o[62], s[64], c[64], o[64]);
  compress42 CP65(s[26],  c[22],  s[27],  c[23],  o[63], s[65], c[65], o[65]);
  compress42 CP66(s[28],  c[24],  s[29],  c[25],  o[64], s[66], c[66], o[66]);
  compress42 CP67(s[30],  c[26],  p[243], c[27],  o[65], s[67], c[67], o[67]);
  compress42 CP68(s[31],  c[28],  s[32],  c[29],  o[66], s[68], c[68], o[68]);
  compress42 CP69(s[33],  c[30],  p[229], p[244], o[67], s[69], c[69], o[69]);
  compress42 CP70(s[34],  c[31],  s[35],  c[32],  o[68], s[70], c[70], o[70]);
  compress42 CP71(p[215], c[33],  p[230], p[245], o[69], s[71], c[71], o[71]);
  compress42 CP72(s[36],  c[34],  s[37],  c[35],  o[70], s[72], c[72], o[72]);
  compress42 CP73(p[201], p[216], p[231], p[246], o[71], s[73], c[73], o[73]);
  compress42 CP74(s[38],  c[36],  p[187], c[37],  o[72], s[74], c[74], o[74]);
  compress42 CP75(p[202], p[217], p[232], p[247], o[73], s[75], c[75], o[75]);
  compress42 CP76(s[39],  c[38],  p[173], p[188], o[74], s[76], c[76], o[76]);
  compress42 CP77(p[203], p[218], p[233], p[248], o[75], s[77], c[77], o[77]);
  compress42 CP78(p[159], c[39],  p[174], p[189], o[76], s[78], c[78], o[78]);
  compress42 CP79(p[204], p[219], p[234], p[249], o[77], s[79], c[79], o[79]);
  compress42 CP80(p[175], p[190], p[205], p[220], o[78], s[80], c[80], o[80]);
  full_adder FA81(p[235], p[250], o[79],  s[81],  c[81]);
  compress42 CP82(p[191], p[206], p[221], p[236], o[80], s[82], c[82], o[82]);
  full_adder FA83(p[207], p[222], o[82],  s[83],  c[83]);

  /// Level 3 (height 2)
  half_adder HA84(p[2],  p[17], s[84], c[84]);
  compress42 CP85(p[3],  p[18], p[33], p[48], 1'b0,  s[85], c[85], o[85]);
  compress42 CP86(s[40], p[34], p[49], p[64], o[85], s[86], c[86], o[86]);
  compress42 CP87(s[41], c[40], p[65], p[80], o[86], s[87], c[87], o[87]);
  compress42 CP88(s[42], c[41], s[43], p[96], o[87], s[88], c[88], o[88]);
  compress42 CP89(s[44], c[42], s[45], c[43], o[88], s[89], c[89], o[89]);
  compress42 CP90(s[46], c[44], s[47], c[45], o[89], s[90], c[90], o[90]);
  compress42 CP91(s[48], c[46], s[49], c[47], o[90], s[91], c[91], o[91]);
  compress42 CP92(s[50], c[48], s[51], c[49], o[91], s[92], c[92], o[92]);
  compress42 CP93(s[52], c[50], s[53], c[51], o[92], s[93], c[93], o[93]);
  compress42 CP94(s[54], c[52], s[55], c[53], o[93], s[94], c[94], o[94]);
  compress42 CP95(s[56], c[54], s[57], c[55], o[94], s[95], c[95], o[95]);
  compress42 CP96(s[58], c[56], s[59], c[57], o[95], s[96], c[96], o[96]);
  compress42 CP97(s[60], c[58], s[61], c[59], o[96], s[97], c[97], o[97]);
  compress42 CP98(s[62], c[60], s[63], c[61], o[97], s[98], c[98], o[98]);
  compress42 CP99(s[64], c[62], s[65], c[63], o[98], s[99], c[99], o[99]);
  compress42 CP100(s[66],  c[64],  s[67],  c[65],  o[99],  s[100], c[100], o[100]);
  compress42 CP101(s[68],  c[66],  s[69],  c[67],  o[100], s[101], c[101], o[101]);
  compress42 CP102(s[70],  c[68],  s[71],  c[69],  o[101], s[102], c[102], o[102]);
  compress42 CP103(s[72],  c[70],  s[73],  c[71],  o[102], s[103], c[103], o[103]);
  compress42 CP104(s[74],  c[72],  s[75],  c[73],  o[103], s[104], c[104], o[104]);
  compress42 CP105(s[76],  c[74],  s[77],  c[75],  o[104], s[105], c[105], o[105]);
  compress42 CP106(s[78],  c[76],  s[79],  c[77],  o[105], s[106], c[106], o[106]);
  compress42 CP107(s[80],  c[78],  s[81],  c[79],  o[106], s[107], c[107], o[107]);
  compress42 CP108(s[82],  c[80],  p[251], c[81],  o[107], s[108], c[108], o[108]);
  compress42 CP109(s[83],  c[82],  p[237], p[252], o[108], s[109], c[109], o[109]);
  compress42 CP110(p[223], c[83],  p[238], p[253], o[109], s[110], c[110], o[110]);
  full_adder FA111(p[239], p[254], o[110], s[111], c[111]);

  /// Carry propogation adder (CPA)
  wire [29:0] cpa_a; 
  wire [29:0] cpa_b; 
  wire [30:0] cpa_sum; 

  assign cpa_a = {p[255], s[111:84], p[1]}; 
  assign cpa_b = {c[111:84], p[32], p[16]};
  assign cpa_sum = cpa_a + cpa_b;

  /// assign result to output
  assign out[0] = p[0];
  assign out[31:1] = cpa_sum[30:0];

endmodule
