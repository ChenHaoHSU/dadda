////////////////////////////////////////////
// Filename: dadda_16x16.v
// Synopsis: 16-by-16 Dadda multiplier
// Author: Chen-Hao Hsu
// Date: April 3, 2023
////////////////////////////////////////////

module DADDA_16x16(a, b, out);

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
  wire [209:0] s;
  wire [209:0] c;

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

  /// Level 1 (height = 13)
  half_adder HA0(p[13],  p[28],          s[0], c[0]);
  full_adder FA1(p[14],  p[29],  p[44],  s[1], c[1]);
  half_adder HA2(p[59],  p[74],          s[2], c[2]);
  full_adder FA3(p[15],  p[30],  p[45],  s[3], c[3]);
  full_adder FA4(p[60],  p[75],  p[90],  s[4], c[4]);
  half_adder HA5(p[105], p[120],         s[5], c[5]);
  full_adder FA6(p[31],  p[46],  p[61],  s[6], c[6]);
  full_adder FA7(p[76],  p[91],  p[106], s[7], c[7]);
  half_adder HA8(p[121], p[136],         s[8], c[8]);
  full_adder FA9(p[47],  p[62],  p[77],  s[9], c[9]);
  full_adder FA10(p[92],  p[107], p[122], s[10], c[10]);
  full_adder FA11(p[63],  p[78],  p[93],  s[11], c[11]);

  /// Level 2 (height = 9)
  half_adder HA12(p[9],   p[24],          s[12], c[12]);

  full_adder FA13(p[10],  p[25],  p[40],  s[13], c[13]);
  half_adder HA14(p[55],  p[70],          s[14], c[14]);

  full_adder FA15(p[11],  p[26],  p[41],  s[15], c[15]);
  full_adder FA16(p[56],  p[71],  p[86],  s[16], c[16]);
  half_adder HA17(p[101], p[116],         s[17], c[17]);

  full_adder FA18(p[12],  p[27],  p[42],  s[18], c[18]);
  full_adder FA19(p[57],  p[72],  p[87],  s[19], c[19]);
  full_adder FA20(p[102], p[117], p[132], s[20], c[20]);
  half_adder HA21(p[147], p[162],         s[21], c[21]);
  
  full_adder FA22(s[0],   p[43],  p[58],  s[22], c[22]);
  full_adder FA23(p[73],  p[88],  p[103], s[23], c[23]);
  full_adder FA24(p[118], p[133], p[148], s[24], c[24]);
  full_adder FA25(p[163], p[178], p[193], s[25], c[25]);
  
  full_adder FA26(c[0],   s[1],   s[2],   s[26], c[26]);
  full_adder FA27(p[89],  p[104], p[119], s[27], c[27]);
  full_adder FA28(p[134], p[149], p[164], s[28], c[28]);
  full_adder FA29(p[179], p[194], p[209], s[29], c[29]);
  
  full_adder FA30(c[1],   c[2],   s[3],   s[30], c[30]);
  full_adder FA31(s[4],   s[5],   p[135], s[31], c[31]);
  full_adder FA32(p[150], p[165], p[180], s[32], c[32]);
  full_adder FA33(p[195], p[210], p[225], s[33], c[33]);
  
  full_adder FA34(c[3],   c[4],   c[5],   s[34], c[34]);
  full_adder FA35(s[6],   s[7],   s[8],   s[35], c[35]);
  full_adder FA36(p[151], p[166], p[181], s[36], c[36]);
  full_adder FA37(p[196], p[211], p[226], s[37], c[37]);

  full_adder FA38(c[6],   c[7],   c[8],   s[38], c[38]);
  full_adder FA39(s[9],   s[10],  p[137], s[39], c[39]);
  full_adder FA40(p[152], p[167], p[182], s[40], c[40]);
  full_adder FA41(p[197], p[212], p[227], s[41], c[41]);

  full_adder FA42(c[9],   c[10],  s[11],  s[42], c[42]);
  full_adder FA43(p[108], p[123], p[138], s[43], c[43]);
  full_adder FA44(p[153], p[168], p[183], s[44], c[44]);
  full_adder FA45(p[198], p[213], p[228], s[45], c[45]);

  full_adder FA46(c[11],  p[79],  p[94],  s[46], c[46]);
  full_adder FA47(p[109], p[124], p[139], s[47], c[47]);
  full_adder FA48(p[154], p[169], p[184], s[48], c[48]);
  full_adder FA49(p[199], p[214], p[229], s[49], c[49]);
  
  full_adder FA50(p[95],  p[110], p[125], s[50], c[50]);
  full_adder FA51(p[140], p[155], p[170], s[51], c[51]);
  full_adder FA52(p[185], p[200], p[215], s[52], c[52]);
  
  full_adder FA53(p[111], p[126], p[141], s[53], c[53]);
  full_adder FA54(p[156], p[171], p[186], s[54], c[54]);
  
  full_adder FA55(p[127], p[142], p[157], s[55], c[55]);
  
  /// Level 3 (height = 6)
  half_adder HA56(p[6],   p[21],          s[56], c[56]);
  full_adder FA57(p[7],   p[22],  p[37],  s[57], c[57]);
  half_adder HA58(p[52],  p[67],          s[58], c[58]);
  full_adder FA59(p[8],   p[23],  p[38],  s[59], c[59]);
  full_adder FA60(p[53],  p[68],  p[83],  s[60], c[60]);
  half_adder HA61(p[98],  p[113],         s[61], c[61]);
  full_adder FA62(s[12],  p[39],  p[54],  s[62], c[62]);
  full_adder FA63(p[69],  p[84],  p[99],  s[63], c[63]);
  full_adder FA64(p[114], p[129], p[144], s[64], c[64]);
  full_adder FA65(c[12],  s[13],  s[14],  s[65], c[65]);
  full_adder FA66(p[85],  p[100], p[115], s[66], c[66]);
  full_adder FA67(p[130], p[145], p[160], s[67], c[67]);
  full_adder FA68(c[13],  c[14],  s[15],  s[68], c[68]);
  full_adder FA69(s[16],  s[17],  p[131], s[69], c[69]);
  full_adder FA70(p[146], p[161], p[176], s[70], c[70]);
  full_adder FA71(c[15],  c[16],  c[17],  s[71], c[71]);
  full_adder FA72(s[18],  s[19],  s[20],  s[72], c[72]);
  full_adder FA73(s[21],  p[177], p[192], s[73], c[73]);

  full_adder FA74(c[18], c[19], c[20], s[74], c[74]);
  full_adder FA75(c[21], s[22], s[23], s[75], c[75]);
  full_adder FA76(s[24], s[25], p[208], s[76], c[76]);
  full_adder FA77(c[22], c[23], c[24], s[77], c[77]);
  full_adder FA78(c[25], s[26], s[27], s[78], c[78]);
  full_adder FA79(s[28], s[29], p[224], s[79], c[79]);
  full_adder FA80(c[26], c[27], c[28], s[80], c[80]);
  full_adder FA81(c[29], s[30], s[31], s[81], c[81]);
  full_adder FA82(s[32], s[33], p[240], s[82], c[82]);
  full_adder FA83(c[30], c[31], c[32], s[83], c[83]);
  full_adder FA84(c[33], s[34], s[35], s[84], c[84]);
  full_adder FA85(s[36], s[37], p[241], s[85], c[85]);
  full_adder FA86(c[34], c[35], c[36], s[86], c[86]);
  full_adder FA87(c[37], s[38], s[39], s[87], c[87]);
  full_adder FA88(s[40], s[41], p[242], s[88], c[88]);
  full_adder FA89(c[38], c[39], c[40], s[89], c[89]);
  full_adder FA90(c[41], s[42], s[43], s[90], c[90]);
  full_adder FA91(s[44], s[45], p[243], s[91], c[91]);
  full_adder FA92(c[42], c[43], c[44], s[92], c[92]);
  full_adder FA93(c[45], s[46], s[47], s[93], c[93]);
  full_adder FA94(s[48], s[49], p[244], s[94], c[94]);
  full_adder FA95(c[46], c[47], c[48], s[95], c[95]);
  full_adder FA96(c[49], s[50], s[51], s[96], c[96]);
  full_adder FA97(s[52], p[230], p[245], s[97], c[97]);

  full_adder FA98(c[50],  c[51],  c[52],  s[98], c[98]);
  full_adder FA99(s[53],  s[54], p[201], s[99], c[99]);
  full_adder FA100(p[216], p[231], p[246], s[100], c[100]);

  full_adder FA101(c[53],   c[54],  s[55],  s[101], c[101]);
  full_adder FA102(p[172],  p[187], p[202], s[102], c[102]);
  full_adder FA103(p[217],  p[232], p[247], s[103], c[103]);

  full_adder FA104(c[55],   p[143], p[158], s[104], c[104]);
  full_adder FA105(p[173],  p[188], p[203], s[105], c[105]);
  full_adder FA106(p[218],  p[233], p[248], s[106], c[106]);

  full_adder FA107(p[159],  p[174], p[189], s[107], c[107]);
  full_adder FA108(p[204],  p[219], p[234], s[108], c[108]);
  full_adder FA109(p[175],  p[190], p[205], s[109], c[109]);

  /// Level 4 (height = 4)
  half_adder HA110(p[4],   p[19],          s[110], c[110]);
  full_adder FA111(p[5],   p[20],  p[35],  s[111], c[111]);
  half_adder HA112(p[50],  p[65],          s[112], c[112]);
  full_adder FA113(s[56],  p[36],  p[51],  s[113], c[113]);
  full_adder FA114(p[66],  p[81],  p[96],  s[114], c[114]);
  full_adder FA115(c[56],  s[57],  s[58],  s[115], c[115]);
  full_adder FA116(p[82],  p[97],  p[112], s[116], c[116]);
  full_adder FA117(c[57],  c[58],  s[59],  s[117], c[117]);
  full_adder FA118(s[60],  s[61],  p[128], s[118], c[118]);

  full_adder FA119(c[59], c[60], c[61], s[119], c[119]);
  full_adder FA120(s[62], s[63], s[64], s[120], c[120]);
  full_adder FA121(c[62], c[63], c[64], s[121], c[121]);
  full_adder FA122(s[65], s[66], s[67], s[122], c[122]);
  full_adder FA123(c[65], c[66], c[67], s[123], c[123]);
  full_adder FA124(s[68], s[69], s[70], s[124], c[124]);
  full_adder FA125(c[68], c[69], c[70], s[125], c[125]);
  full_adder FA126(s[71], s[72], s[73], s[126], c[126]);
  full_adder FA127(c[71], c[72], c[73], s[127], c[127]);
  full_adder FA128(s[74], s[75], s[76], s[128], c[128]);
  full_adder FA129(c[74], c[75], c[76], s[129], c[129]);
  full_adder FA130(s[77], s[78], s[79], s[130], c[130]);
  full_adder FA131(c[77], c[78], c[79], s[131], c[131]);
  full_adder FA132(s[80], s[81], s[82], s[132], c[132]);
  full_adder FA133(c[80], c[81], c[82], s[133], c[133]);
  full_adder FA134(s[83], s[84], s[85], s[134], c[134]);
  full_adder FA135(c[83], c[84], c[85], s[135], c[135]);
  full_adder FA136(s[86], s[87], s[88], s[136], c[136]);
  full_adder FA137(c[86], c[87], c[88], s[137], c[137]);
  full_adder FA138(s[89], s[90], s[91], s[138], c[138]);
  full_adder FA139(c[89], c[90], c[91], s[139], c[139]);
  full_adder FA140(s[92], s[93], s[94], s[140], c[140]);
  full_adder FA141(c[92], c[93], c[94], s[141], c[141]);
  full_adder FA142(s[95], s[96], s[97], s[142], c[142]);
  full_adder FA143(c[95], c[96], c[97], s[143], c[143]);
  full_adder FA144(s[98], s[99], s[100], s[144], c[144]);
  full_adder FA145(c[98], c[99], c[100], s[145], c[145]);
  full_adder FA146(s[101], s[102], s[103], s[146], c[146]);
  full_adder FA147(c[101], c[102], c[103], s[147], c[147]);
  full_adder FA148(s[104], s[105], s[106], s[148], c[148]);
  full_adder FA149(c[104], c[105], c[106], s[149], c[149]);

  full_adder FA150(s[107],  s[108],  p[249], s[150], c[150]);
  full_adder FA151(c[107],  c[108],  s[109], s[151], c[151]);
  full_adder FA152(p[220],  p[235],  p[250], s[152], c[152]);
  full_adder FA153(c[109],  p[191],  p[206], s[153], c[153]);
  full_adder FA154(p[221],  p[236],  p[251], s[154], c[154]);
  full_adder FA155(p[207],  p[222],  p[237], s[155], c[155]);
  
  /// Level 5 (height = 3)
  half_adder HA156(p[3],   p[18],          s[156], c[156]);
  full_adder FA157(s[110], p[34],  p[49],  s[157], c[157]);
  full_adder FA158(c[110], s[111], s[112], s[158], c[158]);
  full_adder FA159(c[111], c[112], s[113], s[159], c[159]);
  full_adder FA160(c[113], c[114], s[115], s[160], c[160]);
  full_adder FA161(c[115], c[116], s[117], s[161], c[161]);
  full_adder FA162(c[117], c[118], s[119], s[162], c[162]);
  full_adder FA163(c[119], c[120], s[121], s[163], c[163]);
  full_adder FA164(c[121], c[122], s[123], s[164], c[164]);
  full_adder FA165(c[123], c[124], s[125], s[165], c[165]);
  full_adder FA166(c[125], c[126], s[127], s[166], c[166]);
  full_adder FA167(c[127], c[128], s[129], s[167], c[167]);
  full_adder FA168(c[129], c[130], s[131], s[168], c[168]);
  full_adder FA169(c[131], c[132], s[133], s[169], c[169]);
  full_adder FA170(c[133], c[134], s[135], s[170], c[170]);
  full_adder FA171(c[135], c[136], s[137], s[171], c[171]);
  full_adder FA172(c[137], c[138], s[139], s[172], c[172]);
  full_adder FA173(c[139], c[140], s[141], s[173], c[173]);
  full_adder FA174(c[141], c[142], s[143], s[174], c[174]);
  full_adder FA175(c[143], c[144], s[145], s[175], c[175]);
  full_adder FA176(c[145], c[146], s[147], s[176], c[176]);
  full_adder FA177(c[147], c[148], s[149], s[177], c[177]);
  full_adder FA178(c[149], c[150], s[151], s[178], c[178]);
  full_adder FA179(c[151], c[152], s[153], s[179], c[179]);
  full_adder FA180(c[153], c[154], s[155], s[180], c[180]);
  full_adder FA181(c[155], p[223], p[238], s[181], c[181]);

  /// Level 6 (height = 2)
  half_adder HA182(p[2],   p[17],          s[182], c[182]);
  full_adder FA183(s[156], p[33],  p[48],  s[183], c[183]);
  full_adder FA184(c[156], s[157], p[64],  s[184], c[184]);
  full_adder FA185(c[157], s[158], p[80],  s[185], c[185]);
  full_adder FA186(c[158], s[159], s[114], s[186], c[186]);
  full_adder FA187(c[159], s[160], s[116], s[187], c[187]);
  full_adder FA188(c[160], s[161], s[118], s[188], c[188]);
  full_adder FA189(c[161], s[162], s[120], s[189], c[189]);
  full_adder FA190(c[162], s[163], s[122], s[190], c[190]);
  full_adder FA191(c[163], s[164], s[124], s[191], c[191]);
  full_adder FA192(c[164], s[165], s[126], s[192], c[192]);
  full_adder FA193(c[165], s[166], s[128], s[193], c[193]);
  full_adder FA194(c[166], s[167], s[130], s[194], c[194]);
  full_adder FA195(c[167], s[168], s[132], s[195], c[195]);
  full_adder FA196(c[168], s[169], s[134], s[196], c[196]);
  full_adder FA197(c[169], s[170], s[136], s[197], c[197]);
  full_adder FA198(c[170], s[171], s[138], s[198], c[198]);
  full_adder FA199(c[171], s[172], s[140], s[199], c[199]);
  full_adder FA200(c[172], s[173], s[142], s[200], c[200]);
  full_adder FA201(c[173], s[174], s[144], s[201], c[201]);
  full_adder FA202(c[174], s[175], s[146], s[202], c[202]);
  full_adder FA203(c[175], s[176], s[148], s[203], c[203]);
  full_adder FA204(c[176], s[177], s[150], s[204], c[204]);
  full_adder FA205(c[177], s[178], s[152], s[205], c[205]);
  full_adder FA206(c[178], s[179], s[154], s[206], c[206]);
  full_adder FA207(c[179], s[180], p[252], s[207], c[207]);
  full_adder FA208(c[180], s[181], p[253], s[208], c[208]);
  full_adder FA209(c[181], p[239], p[254], s[209], c[209]);

  /// Carry propogation adder (CPA)
  wire [29:0] cpa_a; 
  wire [29:0] cpa_b; 
  wire [30:0] cpa_sum; 

  assign cpa_a = {c[209:182], s[182], p[1]}; 
  assign cpa_b = {p[255], s[209:183], p[32], p[16]};
  assign cpa_sum = cpa_a + cpa_b;

  /// assign result to output
  assign out[0] = p[0];
  assign out[31:1] = cpa_sum[30:0];

endmodule
