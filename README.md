# MyCPU

Implementation of TinyMIPS processor for USTB computer composition principle course design.

## TinyMIPS's ISA

### <center> 

| Opcode  | Action |
| ------- | ----------- |
| **Arithmetic Logic Unit** |
| ADDU    | rd=rs+rt    |
| ADDIU   | rt=rs+imm        |
| SUBU    | rd=rs-rt        |
| SLT     | rt=rs<imm         |
| SLTU    | rd=rs<rt         |
| SLTI rt,rs,imm    | rt=rs<imm    |
| SLTIU rt,rs,imm   | rt=rs<imm    |
| AND     | rd=rs&rt         |
| ANDI rt, rs, imm     | rt=rs&imm       |
| NOR rd, rs, rt     | rd=~(rs|rt)        |
| OR      | rd=rs|rt        |
| ORI rt, rs, imm     | rt=rs|imm        |
| XOR     | rd=rs^rt        |
| XORI rt,rs,imm    | rt=rs^imm        |
| LUI     | rt=imm<<16         |
| **Shifter** |
| SLL rd,rt,sa    | rd=rt<<sa        |
| SLLV rd,rs,rt    | rd=rt<<rs    |
| SRA rd,rt,sa   | rd=rt>>sa    |
| SRAV rd,rs,rt   | rd=rt>>rs    |
| SRL rd,rt,sa     | rd=rt>>sa        |
| SRLV rd,rt,sa     | rd=rt>>rs         |
| **Multiply** |
| MULT rs, rt    | HI,LO=rs*rt        |
| MULTU rs, rt    | HI,LO=rs*rt         |
| DIV rs, rt    | HI=rs%rt; LO=rs/rt        |
| DIVU rs,rt    | HI=rs%rt; LO=rs/rt       |
| **Multiply** |
| MULT rs, rt    | HI,LO=rs*rt        |
| MULTU rs, rt    | HI,LO=rs*rt         |
| DIV rs, rt    | HI=rs%rt; LO=rs/rt        |
| DIVU rs,rt    | HI=rs%rt; LO=rs/rt       |
| MFHI rd    | rd=HI       |
| MFLO rd    | rd=LO         |
| MTHI rs    | HI=rs       |
| MTLO rs    | 	LO=rs      |
| **Branch** |
| BEQ rs,rt,offest     | if(rs==rt) pc+=offset*4         |
| BNE rs,rt,offest    | if(rs!=rt) pc+=offset*4       |
| JAL target     | r31=pc; pc=target<<2        |
| JALR rd,rs    | rd=pc; pc=rs         |
| BGEZ rs,offset      | if(rs>=0) pc+=offset*4       |
| BGTZ rs,offset     | if(rs>0) pc+=offset*4       |
| BLEZ rs,offset      | if(rs<=0) pc+=offset*4        |
| BLTZ rs,offset      | if(rs<0) pc+=offset*4         |
| J target     | pc=pc_upper|(target<<2)         |
| JR rs     | 	pc=rs        |
| **Memory Access** |
| LB rt,offest(rs)     | rt=*(char*)(offset+rs)        |
| LBU rt,offset(rs)    | rt=*(Uchar*)(offset+rs      |
| LH rt, offset(rs)     | rt=*(short*)(offset+rs)        |
| LHU rt,offset(rs)   | rt=*(Ushort*)(offset+rs)       |
| LW rt,offset(rs)      | rt=*(int*)(offset+rs)      |
| SB rt,offset(rs)     | *(char*)(offset+rs)=rt      |
| SH rt,offset(rs)     | 	*(short*)(offset+rs)=rt       |
| SW rt,offset(rs)      | 	*(int*)(offset+rs)=rt       |
| **Trap** |
| BREAK      | SignalException(Breakpoint)      |
| SYSCALL     | SignalException(SystemCall)     |
| **Privilege** |
| ERET     | PC<-EPC;Status.EXL<-0;Refresh the pipeline|
| MFC0   | GPR[rt]<-CP0[rd, sel]    |
| MTC0     | CP0[rd, sel]<-GPR[rt]       |
## Note

If you are using Vivado, after importing source files, you may need to do the following things:

1. Go to "Tools - Settings... - General - Verilog options", add `src\cpu\include` to search paths.
2. Select all include files in "Project Manager", then right click and click "Set Global Include".
