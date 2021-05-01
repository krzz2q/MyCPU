`timescale 1ns / 1ps

`include "bus.v"
`include "opcode.v"
`include "funct.v"

module BranchGen(
  input       [`ADDR_BUS]     addr,
  input       [`INST_BUS]     inst,
  input       [`INST_OP_BUS]  op,
  input       [`FUNCT_BUS]    funct,
  input       [`DATA_BUS]     reg_data_1,
  input       [`DATA_BUS]     reg_data_2,
  output  reg                 branch_flag,
  output  reg [`ADDR_BUS]     branch_addr,
  output  reg                 next_inst_delayslot_flag              
);
wire[`ADDR_BUS] addr_plus_4 = addr + 4;
  wire[25:0] jump_addr = inst[25:0];
  wire[`DATA_BUS] sign_ext_imm_sll2 = {{14{inst[15]}}, inst[15:0], 2'b00};

 always @(*) begin
    case (op)
      `OP_JAL: begin
        branch_flag <= 1;
        branch_addr <= {addr_plus_4[31:28], jump_addr, 2'b00};
        next_inst_delayslot_flag <= 1;
      end
    //extended
     `OP_J: begin
        branch_flag <= 1;
        branch_addr <= {addr_plus_4[31:28], jump_addr, 2'b00};
        next_inst_delayslot_flag <= 1;
      end
      `OP_SPECIAL: begin
        if (funct == `FUNCT_JALR|| funct == `FUNCT_JR) begin
          branch_flag <= 1;
          branch_addr <= reg_data_1;
          next_inst_delayslot_flag <= 1;
        end
      //extended
        // else if(funct == `FUNCT_JR) begin
         // branch_flag <= 1;
         // branch_addr <= reg_data_1;
         // next_inst_delayslot_flag <= 1;
        //end
    
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
          next_inst_delayslot_flag <= 0;
        end
      end
      `OP_BEQ: begin
        if (reg_data_1 == reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;  
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
        next_inst_delayslot_flag <= 1;
      end
      `OP_BNE: begin
        if (reg_data_1 != reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
        next_inst_delayslot_flag <= 1;
      end
    // extended
    `OP_BGEZ: begin     // OP_BLTZ与OP_BGEZ一致,需要根据inst[20:16]进一步区分
        // BGEZ&BGEZAL
        if(inst[20:16]==5'b00001||inst[20:16]==5'b10001) begin
          if(reg_data_1[31] == 1'b0) begin//>=0
            branch_flag <= 1;
            branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
          end
          else begin
            branch_flag <= 0;
            branch_addr <= 0;
          end
          next_inst_delayslot_flag <= 1;
        end 
    
     // BLTZ&BLTZAL
        else if(inst[20:16]==5'b00000||inst[20:16]==5'b10000) begin
          if(reg_data_1[31]==1'b1) begin
            branch_flag <= 1;
            branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
          end
          else begin
            branch_flag <= 0;
            branch_addr <= 0;
          end
          next_inst_delayslot_flag <= 1;
        end
    end
    
      `OP_BGTZ: begin
        if(reg_data_1[31]==1'b0 && reg_data_1!=0) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
            branch_flag <= 0;
            branch_addr <= 0;
        end
        next_inst_delayslot_flag <= 1;
      end
    
    `OP_BLEZ: begin
        if(reg_data_1[31]==1'b1 || reg_data_1 == 0) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + sign_ext_imm_sll2;
        end
        else begin
            branch_flag <= 0;
            branch_addr <= 0;
        end
        next_inst_delayslot_flag <= 1;
      end
    
      default: begin
        branch_flag <= 0;
        branch_addr <= 0;
        next_inst_delayslot_flag <= 0;
      end
    endcase
  end

endmodule // BranchGen

 





