`timescale 10 ns/ 1 ns
module RAMtb
  #(parameter
  CLK_REF = 50_000_000,
  N_BYTS = 2,
  WIDTH_CLK_REF = $clog2(CLK_REF), 
  NUM_STATE = 7,
  WIDTH_NUM_STATE = $clog2(NUM_STATE), 
  NUM_OCTAV = 1,
  WIDTH_NUM_OCTAV = $clog2(NUM_OCTAV*7),
  NOTE_MIN = 21,
  WIDTH_RANG_NOTE_MIN = $clog2(CLK_REF/NOTE_MIN),
  NOTE_MAX = 520,
  WIDTH_NOTE_MAX = $clog2(NOTE_MAX),
  SIZE = 4, 
  TEMP = 8,// 1,2,4,8,16,32,64,128,256  
  RANG_TEMP = CLK_REF*SIZE/TEMP,
  WIDTH_RANG_TEMP = $clog2(RANG_TEMP),
  VOLUM = 128// BUZZER/VOLUM
  );
  
  logic clk;
  logic reset_l;
  logic enable_l;
  logic UART_RXD;
  logic UART_TXD;
  logic buzzer_o;
  logic complit;
  logic [WIDTH_NUM_OCTAV-1:0] i_i, i_o;
  logic [7:0] data_to_memory;
  logic full,valid;
  logic loud_sucs;
  logic [ WIDTH_NOTE_MAX-1:0 ] out_data;
  logic start;
  logic sel_adr;
  logic work;
  logic req_f_rcv;

  

  
  RAM #( .CLK_REF(CLK_REF),.N_BYTS(N_BYTS),.NOTE_MIN(NOTE_MIN),.TEMP(TEMP),.VOLUM(VOLUM),.NUM_OCTAV(NUM_OCTAV),.SIZE(SIZE),.NOTE_MAX(NOTE_MAX) ) dut (.*);
  ProgRAM #( .CLK_REF(CLK_REF),.N_BYTS(N_BYTS),.NOTE_MIN(NOTE_MIN),.TEMP(TEMP),.VOLUM(VOLUM),.NUM_OCTAV(NUM_OCTAV),.SIZE(SIZE),.NOTE_MAX(NOTE_MAX) ) pst (.*);

  always #1 clk=~clk;
  initial
    begin
	  clk=0;
	  reset_l=0;

	  @(posedge clk);
	  reset_l=1;

	 #500 $stop;
    end

endmodule 
	 