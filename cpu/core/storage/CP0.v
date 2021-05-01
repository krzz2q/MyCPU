`timescale 1ns / 1ps

`include "bus.v"
`include "cp0def.v"

module CP0(
    input                       clk,
    input                       rst,
    // cp0 cnotrol
    input                       cp0_write_en,
    input       [`CP0_ADDR_BUS] cp0_read_addr,
    input       [`CP0_ADDR_BUS] cp0_write_addr,
    input       [`DATA_BUS]     cp0_write_data,

    // External signal
    input                       eret_flag,
    input                       syscall_flag,
    input                       break_flag,
    input                       delayslot_flag,
    input       [`ADDR_BUS]     current_pc_addr,


    output  reg [`DATA_BUS]     data_o,
    output      [`DATA_BUS]     status_o,
    output      [`DATA_BUS]     cause_o,
    output      [`DATA_BUS]     epc_o
);

    reg[`DATA_BUS] reg_badvaddr;
    reg[ 32 : 0]   reg_count;
    reg[`DATA_BUS] reg_status;
    reg[`DATA_BUS] reg_cause;
    reg[`DATA_BUS] reg_epc;

    wire [`ADDR_BUS] exc_epc;

    assign status_o = reg_status;
    assign cause_o = reg_cause;
    assign epc_o = reg_epc;
    assign exc_epc = delayslot_flag ? current_pc_addr - 4 : current_pc_addr;

    // BADVADDR
   always @(posedge clk) begin
       if (rst) begin
           reg_badvaddr <= 32'h0;
       end
       // only read
       else begin
           reg_badvaddr <= reg_badvaddr;
       end
   end

    // COUNT
    always @(posedge clk) begin
        if (rst) begin
            reg_count <= 33'h0;
        end
        else if (cp0_write_en && cp0_write_addr == `CP0_REG_COUNT) begin
            reg_count <= {cp0_write_data, 1'b0};
        end
        else begin
            reg_count <= reg_count + 1;
        end
    end

    // STATUS
    always @(posedge clk) begin
        if (rst) begin
            reg_status <= 32'h0040ff00;
        end
        else if (break_flag || syscall_flag) begin
            reg_status[1] <= 1;
        end
        else if (eret_flag) begin
            reg_status[1] <= 0;
        end
        else if (cp0_write_en && cp0_write_addr == `CP0_REG_STATUS) begin
            reg_status[22] <= cp0_write_data[22];
            reg_status[15:8] <= cp0_write_data[15:8];
            reg_status[1:0] <= cp0_write_data[1:0];
        end
        else begin
            reg_cause <= reg_cause;
        end
    end

    // CAUSE
    always @(posedge clk) begin
        if (rst) begin
            reg_cause <= 32'h0;
        end
        else if (break_flag || syscall_flag) begin
            reg_cause[31] <= delayslot_flag;
            reg_cause[6:2] <= break_flag ? `CP0_EXCCODE_BP : 
                              syscall_flag ? `CP0_EXCCODE_SYS : 0;
        end
        else if (cp0_write_en && cp0_write_addr == `CP0_REG_CAUSE) begin
            reg_cause[9:8] <= cp0_write_data[9:8];
        end
        else begin
            reg_cause <= reg_cause;
        end
    end

    // EPC
    always @(posedge clk) begin
        if (rst) begin
            reg_epc <= 32'h0;
        end
        else if (break_flag || syscall_flag) begin
            reg_epc <= exc_epc;
        end
        else if (cp0_write_en && cp0_write_addr == `CP0_REG_EPC) begin
            reg_epc <= cp0_write_data;
        end
        else begin
            reg_epc <= reg_epc;
        end
    end

    always @(*) begin
        if(rst) begin
            data_o <= 32'b0;
        end
        else begin
            case (cp0_read_addr)
                `CP0_REG_BADVADDR:  data_o <= reg_badvaddr;
                `CP0_REG_COUNT: data_o <= reg_count[32:1];
                `CP0_REG_STATUS: data_o <= reg_status;
                `CP0_REG_CAUSE: data_o <= reg_cause;
                `CP0_REG_EPC: data_o <= reg_epc;
                default: data_o <= 0;
            endcase
        end
    end

    
endmodule // CP0