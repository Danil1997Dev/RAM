`timescale 10 ns/ 1 ns
`define NUM_OCTAV 1
`define WIDTH_NUM_OCTAV $clog2(`NUM_OCTAV*7) 

typedef enum int{
	  START = 0,
	  START_TRCV_DATA  = 1,
	  TRCV_DATA  = 2,
	  WAIT  = 3,
	  FULL  = 4,
	  WORK = 5, 
	  STOP_WORK = 6,
	  START_TRCV_DATA_WITH_SA  = 7,
	  TRCV_DATA_WITH_SA  = 8,
	  WAIT_WITH_SA  = 9,
	  FULL_WITH_SA  = 10 
} state_t;

  typedef struct packed{
	  logic enable_l;
	  logic full;
	  logic valid;
	  logic start;
	  logic sel_adr;
	  logic req_f_rcv;
  } InValuState_t;

  typedef struct packed{
	  logic [7:0]                                    data_to_memory;
  	  logic [`WIDTH_NUM_OCTAV-1:0]   i_o;
	  logic [`WIDTH_NUM_OCTAV-1:0]   i_i;

  } InData_t;

class START_C;
  task START_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
	  InValuState = 6'b000000;
	  Buffer_o = 0;
	  InData.data_to_memory = 0;
	  InData.i_o = 0;
	  InData.i_i = 0;
        end
  endtask
endclass

class START_TRCV_DATA_C;
  task START_TRCV_DATA_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
	  InValuState = 6'b001110;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory++;
	  InData.data_to_memory = Buffer_i.data_to_memory;
	  InData.i_o = 0;
	  InData.i_i = 0;

	  @(posedge clk);
	  InValuState = 6'b000010;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory;
	  InData.data_to_memory = 0;
	  InData.i_o = 0;
	  InData.i_i = 0;
        end
  endtask
endclass

class TRCV_DATA_C;
  task TRCV_DATA_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
	  InValuState = 6'b001010;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory++;
	  InData.data_to_memory = Buffer_i.data_to_memory;
	  InData.i_o = 0;
	  InData.i_i = 0;

	  @(posedge clk);
	  InValuState = 6'b000010;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory;
	  InData.data_to_memory = 0;
	  InData.i_o = 0;
	  InData.i_i = 0;
        end
  endtask
endclass

class WAIT_C;
  task WAIT_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
      	//forever begin
      	  InValuState = 6'b000010;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory;
	  InData.data_to_memory = Buffer_i.data_to_memory;
	  InData.i_o = 0;
	  InData.i_i = InData.i_i;
       // end
	end
  endtask
endclass

class FULL_C;
  task FULL_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
	  InValuState = 6'b011010;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory;
	  InData.data_to_memory = 8'hFF;
	  InData.i_o = 0;
	  InData.i_i = 0;
        end
  endtask
endclass

class WORK_C;
  task WORK_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
                 InValuState = 6'b110010;
	  Buffer_o.data_to_memory = Buffer_i.i_o++;
	  InData.data_to_memory = 8'hFF;
	  InData.i_o = Buffer_i.i_o;
	  InData.i_i = 0;
        end
  endtask
endclass

class STOP_WORK_C;
  task STOP_WORK_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
                 InValuState = 6'b000011;
	  Buffer_o = Buffer_i;
	  InData.data_to_memory = 8'hFF;
	  InData.i_o = Buffer_i.i_o;
	  InData.i_i = 0;
        end
  endtask
endclass

class START_TRCV_DATA_WITH_SA_C;
  task START_TRCV_DATA_WITH_SA_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
                 InValuState = 6'b001100;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory+5;
	  InData.data_to_memory = Buffer_i.data_to_memory;
	  Buffer_o.i_o = Buffer_i.i_o;
	  InData.i_o = Buffer_i.i_o;
	  InData.i_i = Buffer_i.i_i++;
	  Buffer_o.i_i = Buffer_i.i_i++;
        end
  endtask
endclass

class TRCV_DATA_WITH_SA_C;
  task TRCV_DATA_WITH_SA_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
                 InValuState = 6'b001001;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory+5;
	  InData.data_to_memory = Buffer_i.data_to_memory;
	  Buffer_o.i_o = Buffer_i.i_o;
	  InData.i_o = Buffer_i.i_o;
	  Buffer_o.i_i = Buffer_i.i_i++;
	  InData.i_i = Buffer_i.i_i;
        end
  endtask
endclass

class WAIT_WITH_SA_C;
  task WAIT_WITH_SA_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
      //	forever begin
      	  InValuState = 6'b000000;
	  Buffer_o = Buffer_i;
	  InData.data_to_memory = Buffer_i.data_to_memory;
	  InData.i_o = 0;
	  InData.i_i = Buffer_i.i_i;
      //  end
	end	
  endtask
endclass

class FULL_WITH_SA_C;
  task FULL_WITH_SA_T(ref InValuState_t InValuState,ref InData_t InData,ref InData_t Buffer_o, ref InData_t Buffer_i,ref logic reset_l,ref logic clk);
        begin
                 InValuState = 6'b011000;
	  Buffer_o.data_to_memory = Buffer_i.data_to_memory;
	  InData.data_to_memory = 8'hFF;
	  Buffer_o.i_o = Buffer_i.i_o;
	  InData.i_o = Buffer_i.i_o;
	  Buffer_o.i_i = Buffer_i.i_i++;
	  InData.i_i = Buffer_i.i_i;
        end
  endtask
endclass

class CarryClass; 


  task CarryProg(ref InValuState_t InValuState,ref InData_t InData, ref state_t state,ref logic reset_l,ref logic clk);

static InData_t Buffer_o,Buffer_i;
/*
	  START = 0,
	  START_TRCV_DATA  = 1,
	  TRCV_DATA  = 2,
	  WAIT  = 3,
	  FULL  = 4,
	  WORK = 5, 
	  STOP_WORK = 6,
	  START_TRCV_DATA_WITH_SA  = 7,
	  TRCV_DATA_WITH_SA  = 8,
	  WAIT_WITH_SA  = 9,
	  FULL_WITH_SA  = 10 
*/
begin
//announcement and appropriation objects (name_O) of classes (name_C)
  START_C START_O = new();
  START_TRCV_DATA_C START_TRCV_DATA_O = new();
  TRCV_DATA_C TRCV_DATA_O = new();
  WAIT_C WAIT_O = new();
  FULL_C FULL_O = new();
  WORK_C WORK_O = new();
  STOP_WORK_C STOP_WORK_O = new();
  START_TRCV_DATA_WITH_SA_C START_TRCV_DATA_WITH_SA_O = new();
  TRCV_DATA_WITH_SA_C TRCV_DATA_WITH_SA_O = new();
  WAIT_WITH_SA_C WAIT_WITH_SA_O = new();
  FULL_WITH_SA_C FULL_WITH_SA_O = new();
 if (reset_l) begin
  Buffer_i = Buffer_o;
  unique case ( state )
    START:
      begin
	  START_O.START_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    START_TRCV_DATA:
      begin 
          START_TRCV_DATA_O.START_TRCV_DATA_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    TRCV_DATA:
      begin
	  TRCV_DATA_O.TRCV_DATA_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    WAIT:
      begin 
          WAIT_O.WAIT_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    FULL:
      begin
	  FULL_O.FULL_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    WORK:
      begin 
          WORK_O.WORK_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    STOP_WORK:
      begin
	  STOP_WORK_O.STOP_WORK_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    START_TRCV_DATA_WITH_SA:
      begin 
          START_TRCV_DATA_WITH_SA_O.START_TRCV_DATA_WITH_SA_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    TRCV_DATA_WITH_SA:
      begin
	  TRCV_DATA_WITH_SA_O.TRCV_DATA_WITH_SA_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    WAIT_WITH_SA:
      begin 
          WAIT_WITH_SA_O.WAIT_WITH_SA_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    FULL_WITH_SA:
      begin 
          FULL_WITH_SA_O.FULL_WITH_SA_T(InValuState,InData,Buffer_o, Buffer_i,reset_l,clk);
      end
    
    endcase
   end
      end
  endtask 
  endclass
