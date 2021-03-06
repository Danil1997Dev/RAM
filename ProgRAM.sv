`timescale 10 ns/ 1 ns
`include "intege_rfile.svh"

module ProgRAM
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
  )
  (
  ref logic clk,
  ref logic  reset_l,
  output logic enable_l,
  output logic [WIDTH_NUM_OCTAV-1:0] i_i,i_o,
  output logic [7:0] data_to_memory,//data to memory
  output logic full,valid,
  output logic req_f_rcv,sel_adr,start
  );

  CarryClass ToolCarry;
  state_t state_mod;
  InValuState_t OutValuState;
  InData_t OutData,Buff;

  initial
    begin

      ToolCarry = new;

      $monitor($stime,"InValuState: enable_l=%b,full=%b,valid=%b,start=%b,sel_adr=%b,req_f_rcv=%b", enable_l,full,valid,start,sel_adr,req_f_rcv,
                           "/n InData:         data_to_memory=%h,i_o=%d,i_i=%d", data_to_memory,i_o,i_i);
/*	  START = 0,
	  START_TRCV_DATA  = 1,
	  TRCV_DATA  = 2,
	  WAIT  = 3,
	  FULL  = 4,
	  WORK = 5, 
	  STOP_WORK = 6,
	  START_TRCV_DATA_WITH_SA  = 7,
	  TRCV_DATA_WITH_SA  = 8,
	  WAIT_WITH_SA  = 9,
	  FULL_WITH_SA  = 10           */

      @(posedge clk);
      state_mod = START;
      enable_l = 0;
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #25@(posedge clk);
      state_mod = START_TRCV_DATA;
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      @(posedge clk);
      state_mod = WAIT;//WAIT
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #10@(posedge clk);
      state_mod = TRCV_DATA;//TRCV_DATA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      @(posedge clk);
      state_mod = WAIT;//WAIT
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #10@(posedge clk);
      state_mod = TRCV_DATA;//TRCV_DATA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);
      @(posedge clk);
      state_mod = WAIT;//WAIT
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #10@(posedge clk);
      state_mod = TRCV_DATA;//TRCV_DATA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      @(posedge clk);
      state_mod = WAIT;//WAIT
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #10@(posedge clk);
      state_mod = FULL;//FULL
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #50@(posedge clk);
      state_mod = WORK;//WORK
      enable_l = 1;
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #50@(posedge clk);
      state_mod = WORK;//WORK
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #10@(posedge clk);
      state_mod = STOP_WORK;//STOP_WORK
      enable_l = 0;
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #50@(posedge clk);
      state_mod = START_TRCV_DATA_WITH_SA;//START_TRCV_DATA_WITH_SA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      @(posedge clk);
      state_mod = TRCV_DATA_WITH_SA;//TRCV_DATA_WITH_SA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #11@(posedge clk);
      state_mod = TRCV_DATA_WITH_SA;//TRCV_DATA_WITH_SA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #11@(posedge clk);
      state_mod = WAIT_WITH_SA;//WAIT_WITH_SA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #11@(posedge clk);
      state_mod = TRCV_DATA_WITH_SA;//TRCV_DATA_WITH_SA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #11@(posedge clk);
      state_mod = FULL_WITH_SA;//FULL_WITH_SA
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

      #500@(posedge clk);
      state_mod = WORK;//WORK
      enable_l = 1;
      ToolCarry.CarryProg( OutValuState,OutData, state_mod,reset_l,clk);

     // #100 $stop;
    end

  always @*
	begin
	  enable_l = OutValuState.enable_l;
	  full = OutValuState.full;
	  valid = OutValuState.valid;
	  start = OutValuState.start;
	  sel_adr = OutValuState.sel_adr;
	  req_f_rcv = OutValuState.req_f_rcv;
	  data_to_memory = OutData.data_to_memory;
  	  i_o = OutData.i_o;
	  i_i = OutData.i_i;
	  Buff = ToolCarry.CarryProg.Buffer_o;
	end
endmodule 