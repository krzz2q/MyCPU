`timescale 1ns / 1ps

`include "bus.v"
`include "opcode.v"
`include "funct.v"

module FunctGen(
  input       [`INST_OP_BUS]  op,
  input       [`INST_BUS]     inst,
  input       [`FUNCT_BUS]    funct_in,
  output  reg [`FUNCT_BUS]    funct
);
  wire[`INST_OP_BUS+5]  ex_op = {op,inst[20:16]}; 
  
  // generating FUNCT signal in order for the ALU to perform operations
  always @(*) begin
    case (op)
      `OP_SPECIAL: funct <= funct_in;
      `OP_LUI: funct <= `FUNCT_OR;
      `OP_LB, `OP_LBU, `OP_LW, `OP_LH, `OP_LHU,
      `OP_SB, `OP_SW, `OP_SH, `OP_ADDIU: funct <= `FUNCT_ADDU;
      `OP_JAL, `OP_ORI: funct <= `FUNCT_OR;
      `OP_BGEZ:begin
      if(ex_op=={`OP_BGEZ,5'b10001}||ex_op=={`OP_BGEZ,5'b10000})begin
        funct <= `FUNCT_OR;
     end
      else begin
       funct <= `FUNCT_NOP;
      end
      end
      // -- Extended --
      `OP_ANDI: funct <= `FUNCT_AND;
      `OP_XORI: funct <= `FUNCT_XOR;
      `OP_SLTI: funct<= `FUNCT_SLT;     // SLTI和SLT都是有符号数比较
      `OP_SLTIU: funct <= `FUNCT_SLTU;  // SLTIU和SLTU都是无符号数比较
      default: funct <= `FUNCT_NOP;
    endcase
  end

endmodule // FunctGen
