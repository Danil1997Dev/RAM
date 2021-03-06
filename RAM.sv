module RAM
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
  input clk,
  input reset_l,enable_l,
  input start,
  input [WIDTH_NUM_OCTAV-1:0] i_i,
  input [WIDTH_NUM_OCTAV-1:0] i_o,
  input [7:0] data_to_memory,//data to memory
  input full,valid,
  input sel_adr,
  input req_f_rcv,
  output reg loud_sucs,//redy for load data to memory
  output reg [ WIDTH_NOTE_MAX-1:0 ] out_data,
  output reg work

  );
  
  logic [ WIDTH_NOTE_MAX-1:0 ] note_frecuncy  [0:NUM_OCTAV*7-1];
  logic [7:0] buffer;
  logic redy;
  logic ls;
  logic [7:0] chek_reg;
  
  logic addr;
  
  typedef struct packed{
  bit start;
  bit valid;
  bit ls;
  bit full;
  } param_enum_t;
  
  param_enum_t param_enum;
  
  assign param_enum.start = start;
  assign param_enum.valid = valid;
  assign param_enum.ls    = ls;
  assign param_enum.full  = full;
  
  //memory
  


  logic [ $clog2(NUM_OCTAV*7)-1:0 ] n = 0;
  logic [ N_BYTS-1:0 ] [ 7:0 ] byts = 0;
  logic [ N_BYTS*8-1:0 ] data;
  logic [ $clog2(N_BYTS)-1:0 ]m = 1'b0;

  enum int unsigned{
	  START_MEM = 0, 
	  WAIT_MEM  = 1,
	  LOUD_MEM  = 2,
	  CHEK_MEM  = 3,
	  FULL_MEM  = 4
  } state,next_state;
  
  
  //end counted state machin 

  
  always@( posedge clk or negedge reset_l )
	  begin
		 if ( !reset_l ) 
			begin
				state  <=  START_MEM;
			end
		 else 
			begin 
				state  <=  next_state;
			end
	  end
	  
  always @(*)
	  begin
		 unique case( state )
			START_MEM:  begin
							 if ( !reset_l || enable_l ) 
								begin
									next_state =  START_MEM;
								end 
							 else 
								begin
									if ( !enable_l && param_enum == 4'b1100 )  
										begin
											next_state =  LOUD_MEM;
										end
									else 
										begin
											next_state =  START_MEM;
										end
							 
								end		
							end
		      WAIT_MEM:begin
								if ( !enable_l && param_enum == 4'b0100 )  
									begin
										next_state =  LOUD_MEM;
									end 
								else if ( !enable_l && param_enum == 4'b0010 ) 
									begin
										next_state =  CHEK_MEM;
									end
								else if ( !enable_l && (param_enum == 4'b0101 || param_enum == 4'b0001) ) 
									begin
										next_state =  FULL_MEM;
									end
								else 
									begin
										next_state =  WAIT_MEM;
									end
							end  
			  LOUD_MEM: begin
								if ( !enable_l && param_enum == 4'b0010 )  
									begin
										next_state =  CHEK_MEM;
									end 
								else
									begin
										next_state =  WAIT_MEM;
									end
							end
		     CHEK_MEM: begin
								next_state =  WAIT_MEM;
							end
		     FULL_MEM: begin
							 if ( !reset_l || req_f_rcv ) 
								 begin
									next_state =  START_MEM;
								 end 
							 else 
								 begin
									next_state =  FULL_MEM;
								 end
							end
		 endcase
	  end

  logic [WIDTH_NUM_OCTAV-1:0] adr_buf;
	  
  always@( posedge clk )
    begin
      if ( state == START_MEM )
		  begin
			if ( param_enum == 4'b1100 )  
				begin
					buffer	  = data_to_memory;
					chek_reg = data_to_memory;
					m     	  = 0;
					n     	  = 1'b0;
					adr_buf    = adr_buf;
					redy 	  	  = 1'b0;
					loud_sucs  = 1'b0;
				end
			else 
				begin
					buffer	  = buffer;
					chek_reg = chek_reg;
					m     	  = 0;
					n     	  = 1'b0;
					adr_buf    = adr_buf;
					redy 	  	  = 1'b0;
					loud_sucs  = 1'b0;
				end
		  end
		else if ( state == WAIT_MEM )
		  begin
			if (param_enum == 4'b0100)
			  begin
				 buffer	  = data_to_memory;
			  	 chek_reg = data_to_memory;
				 m     	  = m+1'b1;
				 n     	  = n;
				 adr_buf   = adr_buf;
				 redy 	  = 1'b0;
				 loud_sucs = 1'b0;
			  end
			else if (param_enum == 4'b0010)
			  begin
				 buffer	  = buffer;
				 chek_reg = chek_reg;
				 m     	  = m;
				 n     	  = n;
				 adr_buf   = adr_buf;
				 redy 	  = 1'b0;
				 loud_sucs = 1'b0;
			  end
			else if (param_enum == 4'b0101)
			  begin
				 buffer	  = buffer;
				 chek_reg = chek_reg;
				 m     	  = m;
				 n     	  = n;
				 adr_buf   = adr_buf;
				 redy 	  = 1'b0;
				 loud_sucs = 1'b0;
			  end
			else if (param_enum == 4'b0000)
			  begin
				 buffer	  = buffer;
				 chek_reg = chek_reg;
				 m     	  = m;
				 n     	  = n;
				 adr_buf   = adr_buf;
				 redy 	  = 1'b0;
				 loud_sucs = 1'b0;
			  end
			else 
			  begin
				 buffer	  = buffer;
				 chek_reg = chek_reg;
				 m     	  = m;
				 n     	  = n;
				 adr_buf   = adr_buf;
				 redy 	  = 1'b0;
				 loud_sucs = 1'b0;
			  end
		  end
		else if ( state == LOUD_MEM )
		  begin
			if ( m == N_BYTS-1 ) 
				begin
					byts[ m ] = buffer;
					chek_reg = chek_reg;
					m     	 = m;
					n     	 = n;
					adr_buf 	 = i_i;
					redy 	 	 = 1'b0;
					loud_sucs = 1'b0;
				end 
			else 
				begin
					byts[ m ] = buffer;
				 	chek_reg = chek_reg;
					m     	 =  m;
					n     	 =  n;
					adr_buf 	 = adr_buf;
					redy 	    = 1'b0;
					loud_sucs = 1'b0;
				end
		  end
		else if ( state == CHEK_MEM )
		  begin
                    if (m == N_BYTS-1)
		    begin
		    loud_sucs <= 1'b1;
			 byts[ m ] = buffer;
			 chek_reg = 0;
			 m     	  =  m;
			 n     	  <=  n+1'b1;
			 adr_buf   = adr_buf;
			 redy 	  = 1'b0;
		    end
                    else
		    begin
		    loud_sucs <= 1'b1;
			 byts[ m ] = buffer;
			 chek_reg = 0;
			 m     	  =  m;
			 n     	  <=  n;
			 adr_buf   = adr_buf;
			 redy 	  = 1'b0;
		    end
		  end
		else if ( state == FULL_MEM )
		  begin
		    redy 	  = 1'b1;
			 byts[ m ] = buffer;
			 chek_reg = 0;
			 m     	  =  m;
			 n     	   =  n;
			 adr_buf   = adr_buf;
			 loud_sucs = 1'b0;
		  end
	 end
  
  logic [ $clog2(NUM_OCTAV*7)-1:0 ] num;

  assign num = (sel_adr) ? n : adr_buf;
	  
  always@( posedge clk )
    begin
	   if ( reset_l && !enable_l )
		  begin
			if ( m == N_BYTS-1 ) 
				begin
				  data 				 	 <= byts;
				  note_frecuncy[num]  <= data[ WIDTH_NOTE_MAX-1:0 ];//louding data to memory
				end 
			else 
				begin
				  data 				  	 <= data;
				  note_frecuncy[num]  <= note_frecuncy[num];
				end
		  end
	 end
  //end memory
  
  //chek louded
  
  logic ch;
  assign ch = (chek_reg ==  byts[ m ]);
  always@( posedge clk )
	  begin
		 if ( chek_reg ==  byts[ m ] )
		  begin
			ls       	    <= 1'b1;
		  end
		 else
		  begin
			ls       	    <= 1'b0;
		  end
	  end
  //end chek louded
  
  //transmit data to buzzer
  always@( posedge clk )
	  begin
		 if (redy) 
		  begin
			out_data = note_frecuncy[i_o];
			work       	         = 1'b1;
		  end
		 else
		  begin
			out_data 				= 0;
			work       	         = 1'b0;
		  end
	  end

endmodule 