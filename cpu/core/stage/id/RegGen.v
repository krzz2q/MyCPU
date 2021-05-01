`timescale 1ns / 1ps

`include "bus.v"
`include "opcode.v"
`include "cp0def.v"

module RegGen(
  input       [`INST_OP_BUS]  op,
  input       [`REG_ADDR_BUS] rs,
  input       [`INST_BUS]     inst,
  input       [`REG_ADDR_BUS] rt,
  input       [`REG_ADDR_BUS] rd,
  output  reg                 reg_read_en_1,
  output  reg                 reg_read_en_2,
  output  reg [`REG_ADDR_BUS] reg_addr_1,
  output  reg [`REG_ADDR_BUS] reg_addr_2,
  output  reg                 reg_write_en,
  output  reg [`REG_ADDR_BUS] reg_write_addr
);
wire[`INST_OP_BUS+5]  ex_op = {op,inst[20:16]}; 
  // generate read address
  always @(*) begin
    case (op)
      // arithmetic & logic (immediate)
      `OP_ADDIU,`OP_ANDI,`OP_ORI,`OP_XORI,`OP_SLTI, `OP_SLTIU,
	  // extended branch
      `OP_BGEZ, `OP_BGTZ, `OP_BLEZ, `OP_BLTZ,
      //`OP_BGEZAL,`OP_BLTZAL, 
      // memory accessing
      `OP_LB, `OP_LW, `OP_LBU, `OP_LH, `OP_LHU: begin
        reg_read_en_1 <= 1;
        reg_read_en_2 <= 0;
        reg_addr_1 <= rs;
        reg_addr_2 <= 0;
      end
      // branch
      `OP_BEQ, `OP_BNE,
      // memory accessing
      `OP_SB, `OP_SW,`OP_SH,
      // r-type
      `OP_SPECIAL: begin
        reg_read_en_1 <= 1;
        reg_read_en_2 <= 1;
        reg_addr_1 <= rs;
        reg_addr_2 <= rt;
      end

      `OP_CP0: begin
        reg_read_en_1 <= 1;
        reg_read_en_2 <= 0;
        reg_addr_1 <= rt;
        reg_addr_2 <= 0;
      end

      default: begin  // OP_JAL, OP_LUI
        reg_read_en_1 <= 0;
        reg_read_en_2 <= 0;
        reg_addr_1 <= 0;
        reg_addr_2 <= 0;
      end
    endcase
  end

  // generate write address
  always @(*) begin
    case (op)
      // immediate
      `OP_ADDIU, `OP_LUI, `OP_ANDI,`OP_XORI,`OP_ORI, `OP_SLTI, `OP_SLTIU,`OP_LB, `OP_LBU, `OP_LW, `OP_LH, `OP_LHU: begin
        reg_write_en <= 1;
        reg_write_addr <= rt;
      end
      `OP_SPECIAL: begin
        reg_write_en <= 1;
        reg_write_addr <= rd;
      end
     `OP_JAL: begin
        reg_write_en <= 1;
        reg_write_addr <= 31;   // $ra (return address)
      end 
      `OP_BGEZ:begin
      if(ex_op=={`OP_BGEZ,5'b10001}||ex_op=={`OP_BGEZ,5'b10000})begin
        reg_write_en <= 1;
        reg_write_addr <= 31;   // $ra (return address)
     end
      else begin
        reg_write_en <= 0;
        reg_write_addr <= 0;
      end
      end
      //`OP_LB, `OP_LBU, `OP_LW, `OP_LH, `OP_LHU: begin
       // reg_write_en <= 1;
        //reg_write_addr <= rt;
     // end

      `OP_CP0: begin
        if (rs == `CP0_MFC0) begin
          reg_write_en <= 1;
          reg_write_addr <= rt;
        end
        else begin
          reg_write_en <= 0;
          reg_write_addr <= 0;
        end
      end

      default: begin
        reg_write_en <= 0;
        reg_write_addr <= 0;
      end
    endcase
  end

endmodule // RegGen
