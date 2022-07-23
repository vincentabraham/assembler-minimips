`define NULL 0 // Defining the NULL constant
module assembler();
  reg [31:0]loc = 5'h0; // Instruction Location Counter
  reg [5:0]opcode; // Opcode
  reg [5:0]opcode_ex; // Opcode Extension
  reg [4:0]rs; // Source Register
  reg [4:0]rt; // Source Register 2/ Destination Register
  reg [4:0]rd; // Destination Register
  reg [4:0]sh; // Shift Operand
  reg [15:0]imm_off; // Immediate Operand/Offset
 
  // Results of scanning(strings) would be stored here
  reg [8*7:0]op_scan;
  reg [50*7:0]temp_rs, temp_rt, temp_rd, temp_sh;
   
  integer file, op_file, r; // For reading & writing in files
  
  function [4:0]assign_reg;
    // Takes registers as strings and assigns the corresponding binary values
    input [50*7:0]reg_str;
    begin
    case(reg_str)
      "$s0,":
        assign_reg = 5'b10000;
      "$s1,":
        assign_reg = 5'b10001;
		  "$s2,":
        assign_reg = 5'b10010;
      "$s3,":
        assign_reg = 5'b10011;
		  "$s4,":
        assign_reg = 5'b10100;
      "$s5,":
        assign_reg = 5'b10101;
		  "$s6,":
        assign_reg = 5'b10110;
      "$s7,":
        assign_reg = 5'b10111;
      "$t0,":
        assign_reg = 5'b01000;
		  "$t1,":
        assign_reg = 5'b01001;
		  "$t2,":
        assign_reg = 5'b01010;
		  "$t3,":
        assign_reg = 5'b01011;
		  "$t4,":
        assign_reg = 5'b01100;
		  "$t5,":
        assign_reg = 5'b01101;
		  "$t6,":
        assign_reg = 5'b01110;
		  "$t7,":
        assign_reg = 5'b01111;
		  "$t8,":
        assign_reg = 5'b11000;
		  "$t9,":
        assign_reg = 5'b11001;
      //Error Handling
      default:
        begin
          $display("Invalid register: %0s exit.", reg_str);
          $finish;
        end
    endcase
    end
  endfunction
 
  function [4:0]assign_rt;
    // Takes registers as strings and assigns the corresponding binary values
    input [50*7:0]reg_str;

    begin
    case(reg_str)
      "$s0":
        assign_rt = 5'b10000;
      "$s1":
        assign_rt = 5'b10001;
		  "$s2":
        assign_rt = 5'b10010;
      "$s3":
        assign_rt = 5'b10011;
		  "$s4":
        assign_rt = 5'b10100;
      "$s5":
        assign_rt = 5'b10101;
		  "$s6":
        assign_rt = 5'b10110;
      "$s7":
        assign_rt = 5'b10111;
      "$t0":
        assign_rt = 5'b01000;
		  "$t1":
        assign_rt = 5'b01001;
		  "$t2":
        assign_rt = 5'b01010;
		  "$t3":
        assign_rt = 5'b01011;
		  "$t4":
        assign_rt = 5'b01100;
		  "$t5":
        assign_rt = 5'b01101;
		  "$t6":
        assign_rt = 5'b01110;
		  "$t7":
        assign_rt = 5'b01111;
		  "$t8":
        assign_rt = 5'b11000;
		  "$t9":
        assign_rt = 5'b11001;
      // Error Handling
      default:
        begin
          $display("Invalid register: %0s, exit.", reg_str);
          $finish;
        end
    endcase
    end
  endfunction
  
  function [4:0]assign_reg_ls;
    // Takes registers as strings and assigns the corresponding binary values
    input [50*7:0]reg_str;

    begin
    case(reg_str)
      "($s0)":
        assign_reg_ls = 5'b10000;
      "($s1)":
        assign_reg_ls = 5'b10001;
		  "($s2)":
        assign_reg_ls = 5'b10010;
      "($s3)":
        assign_reg_ls = 5'b10011;
		  "($s4)":
        assign_reg_ls = 5'b10100;
      "($s5)":
        assign_reg_ls = 5'b10101;
		  "($s6)":
        assign_reg_ls = 5'b10110;
      "($s7)":
        assign_reg_ls = 5'b10111;
      "($t0)":
        assign_reg_ls = 5'b01000;
		  "($t1)":
        assign_reg_ls = 5'b01001;
		  "($t2)":
        assign_reg_ls = 5'b01010;
		  "($t3)":
        assign_reg_ls = 5'b01011;
		  "($t4)":
        assign_reg_ls = 5'b01100;
		  "($t5)":
        assign_reg_ls = 5'b01101;
		  "($t6)":
        assign_reg_ls = 5'b01110;
		  "($t7)":
        assign_reg_ls = 5'b01111;
		  "($t8)":
        assign_reg_ls = 5'b11000;
		  "($t9)":
        assign_reg_ls = 5'b11001;
      // Error Handling
      default:
        begin
          $display("Invalid register: %0s, exit.", reg_str);
          $finish;
        end
    endcase
    end
  endfunction
 
  initial
    // Scanning the file
    begin : file_tread
      file = $fopen("script1.txt", "r");
      op_file = $fopen("assembler_output1.txt", "w");
            
      if(file == `NULL)
        disable file_tread;
        
      $display("Address         Instruction\n");
      
      while (!$feof(file))
        begin
          r = $fscanf(file, "%s \n", op_scan); // First scanning only the operation
          
          // Assigning the corresponding opcodes & opcode extensions
          case(op_scan)
            "add":
				      begin
                opcode = 6'b000000;
				        opcode_ex = 6'b100000;
				      end
            "sub":
				      begin
                opcode = 6'b000000;
				        opcode_ex = 6'b100010;
				      end
            "addi": opcode = 6'b001000; 
				    "sll":
				      begin
                opcode = 6'b000000;
				        opcode_ex = 6'b000000;
				      end
            "and":
				      begin
                opcode = 6'b000000;
				        opcode_ex = 6'b100100;
				      end
            "ori": opcode = 6'b001101;
				    "sw": opcode = 6'b101011;
            "lw": opcode = 6'b100011;
            "slti": opcode = 6'b001010;
				    "xor": 
				      begin
                opcode = 6'b000000;
				        opcode_ex = 6'b100110;
				      end
            default:
              // Error Handling
              begin
                $display("Invalid Command: %0s, exit.", op_scan);
                disable file_tread;
              end
          endcase
         
          if(opcode == 6'b000000) // For ALU type operations
				    begin
						  if(opcode_ex == 6'b000000) //for sll instruction
							 begin
							   r = $fscanf(file, " %0s %0s %d \n", temp_rd, temp_rt, sh);
							   rd = assign_reg(temp_rd);
							   rs = 5'b00000;
							   rt = assign_reg(temp_rt);
							   $display("%0h         %b %b %b %b %b %b", loc, opcode, rs, rt, rd, sh, opcode_ex); // Displaying the machine code
							   $fwrite(op_file, "%0h         %b %b %b %b %b %b\n", loc, opcode, rs, rt, rd, sh, opcode_ex);
							 end
						  else
							 begin
							   r = $fscanf(file, " %0s %0s %0s \n", temp_rd, temp_rs, temp_rt);
							   rd = assign_reg(temp_rd);
							   rs = assign_reg(temp_rs);
							   rt = assign_rt(temp_rt);
							   sh = 5'b00000; // Shift amount would be zero
							   $display("%0h         %b %b %b %b %b %b", loc, opcode, rs, rt, rd, sh, opcode_ex); // Displaying the machine code
							   $fwrite(op_file, "%0h         %b %b %b %b %b %b\n", loc, opcode, rs, rt, rd, sh, opcode_ex);
							 end
				   end
			    else if(opcode == 6'b101011 || opcode == 6'b100011) // For sw/lw instruction
				    begin
						  r = $fscanf(file, " %0s %d %0s \n", temp_rt, imm_off, temp_rs);
              rt = assign_reg(temp_rt);
              rs = assign_reg_ls(temp_rs);
              $display("%0h         %b %b %b %b", loc, opcode, rs, rt, imm_off); // Displaying the machine code
              $fwrite(op_file, "%0h         %b %b %b %b\n", loc, opcode, rs, rt, imm_off);
				    end
          else
            // For I type operations
            begin
              r = $fscanf(file, " %0s %0s %d \n", temp_rd, temp_rs, imm_off);
              rd = assign_reg(temp_rd);
              rs = assign_reg(temp_rs);
              $display("%0h         %b %b %b %b", loc, opcode, rd, rs, imm_off); // Displaying the machine code
              $fwrite(op_file, "%0h         %b %b %b %b\n", loc, opcode, rd, rs, imm_off);
            end
        loc = loc + 5'h4; // Increementing the location
        end
        $fclose(file);  
    end
endmodule