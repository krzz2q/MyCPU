`ifndef TINYMIPS_OPCODE_V_
`define TINYMIPS_OPCODE_V_

// r-type (SPECIAL)
`define OP_SPECIAL    6'b000000

// j-type
`define OP_JAL        6'b000011
//extended
`define OP_J          6'b000010
//`define OP_JR         6'b000000

// branch
`define OP_BEQ        6'b000100
`define OP_BNE        6'b000101
//extended  // OP_BLTZ与OP_BGEZ一致,需要进一步区分
`define OP_BGEZ       6'b000001     
`define OP_BGTZ       6'b000111
`define OP_BLEZ       6'b000110 
`define OP_BLTZ       6'b000001

//`define OP_BGEZAL     6'b000001
//`define OP_BLTZAL     6'b000001
// arithmetic
`define OP_ADDIU      6'b001001
//extended
`define OP_SLTI       6'b001010
`define OP_SLTIU      6'b001011
`define OP_ANDI       6'b001100
`define OP_NOR        6'b000000
`define OP_ORI        6'b001101
`define OP_XORI       6'b001110
`define OP_SRA        6'b000000
`define OP_SRL        6'b000000

// immediate
`define OP_LUI        6'b001111

// memory accessing
`define OP_LB         6'b100000
`define OP_LW         6'b100011
`define OP_LBU        6'b100100
`define OP_SB         6'b101000
`define OP_SW         6'b101011
//extended
`define OP_LH         6'b100001
`define OP_LHU        6'b100101
`define OP_SH         6'b101001

// coprocessor
`define OP_CP0        6'b010000

`endif  // TINYMIPS_OPCODE_V_
