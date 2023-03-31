`timescale 1ns/10ps
`define CYCLE 10
`define END_CYCLE 2000 // How many cycles of the whole simulation
`define BIT 8
`define N_DATA 100

module test;
	reg clock;
  reg data_valid;

  reg [`BIT - 1 : 0] data_in_a;
  reg [`BIT - 1 : 0] data_in_b;
  
  wire [`BIT * 2 - 1 : 0] data_out;
  reg [`BIT * 2 - 1 : 0] golden_data;

  reg [9:0] data_idx;
  
  //////////////////////////////////////
  /// Read input data & golden answer
  //////////////////////////////////////
  reg [`BIT * 2 - 1 : 0] data_mem [0 : `N_DATA - 1];
  initial $readmemh("./data/mul8x8.dat", data_mem);
  reg [`BIT * 2 - 1 : 0] golden_mem [0 : `N_DATA - 1];
  initial $readmemh("./data/mul8x8_golden.dat", golden_mem);

  integer i, j;
  integer n_fail;
  initial begin
    i = 0;
    j = 0;
    n_fail = 0;
  end

  initial begin
    clock = 0;
    data_valid = 0;
    data_idx = 0;
    data_in_a = 0;
    data_in_b = 0;
    golden_data = 0;

    #(`CYCLE);
    #(`CYCLE);
    @(negedge clock);
    #(`CYCLE);
    for (i = 0; i < `N_DATA; i = i + 1) begin
      @(negedge clock);
      data_valid = 1;
      data_idx = data_idx + 1;
      data_in_a = data_mem[i][`BIT * 2 - 1 : `BIT];
      data_in_b = data_mem[i][`BIT - 1 : 0];
      golden_data = golden_mem[i];
    end
    @(negedge clock);
    data_valid = 0;
    #(`CYCLE * 10);
    $finish; 
  end
	
  always @ (posedge clock) begin
    if (data_valid) begin 
      if (data_out != golden_data) begin
        n_fail = n_fail + 1;
        $display("Wrong!! Data %5d, %4d * %4d: %8d (test) != %8d (golden)",
          data_idx, data_in_a, data_in_b, data_out, golden_data);
      end else begin
        $display("Correct!! Data %5d, %4d * %4d: %8d (test) == %8d (golden)",
          data_idx, data_in_a, data_in_b, data_out, golden_data);
      end
    end
  end


  DADDA_8x8 mul(
    .a(data_in_a),
    .b(data_in_b),
    .out(data_out)
  );

  always begin 
	  #(`CYCLE / 2)  clock = ~clock;
  end

  initial begin
    #(`CYCLE * `END_CYCLE);
    $display("--------------------------------------------\n");
    $display("Error! Exceed time limit.....\n");
    $display("--------------------------------------------\n");
    $finish;
  end
 
  initial begin
    wait(data_idx >= `N_DATA);
    #(`CYCLE * 4)
    if (n_fail == 0) begin 
      $display("--------------------------------------------\n");
      $display("Pass! Total %6d data.\n",
                `N_DATA);
      $display("--------------------------------------------\n");
    end else begin
      $display("--------------------------------------------\n");
      $display("Fail! %6d data incorrect (total %6d)......\n",
                n_fail, `N_DATA);
      $display("--------------------------------------------\n");
    end
    #(`CYCLE)
    $finish;
  end

endmodule
