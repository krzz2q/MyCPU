// coprocessor instructions
`define CP0_MFC0                 5'b00000
`define CP0_MTC0                 5'b00100
`define CP0_ERET                 5'b10000
`define CP0_ERET_FULL            32'h42000018

// coprocessor 0 register address definitions
`define CP0_REG_BADVADDR         8'b01000000
`define CP0_REG_COUNT            8'b01001000
`define CP0_REG_COMPARE          8'b01011000
`define CP0_REG_STATUS           8'b01100000
`define CP0_REG_CAUSE            8'b01101000
`define CP0_REG_EPC              8'b01110000
`define CP0_REG_PRID             8'b01111000
`define CP0_REG_EBASE            8'b01111001
`define CP0_REG_CONFIG0          8'b10000000
`define CP0_REG_CONFIG1          8'b10000001

// ExcCode definitions
`define CP0_EXCCODE_INT          8'h00
`define CP0_EXCCODE_ADEL         8'h04
`define CP0_EXCCODE_ADES         8'h05
`define CP0_EXCCODE_SYS          8'h08
`define CP0_EXCCODE_BP           8'h09
`define CP0_EXCCODE_RI           8'h0a
`define CP0_EXCCODE_OV           8'h0c
