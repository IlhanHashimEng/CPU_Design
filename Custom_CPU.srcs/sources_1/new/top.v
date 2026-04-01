`timescale 1ns / 1ps

///////////fields of IR
`define oper_type IR[31:27]
`define rdst      IR[26:22]
`define rsrc1     IR[21:17]
`define imm_mode  IR[16]
`define rsrc2     IR[15:11]
`define isrc      IR[15:0]


//////////////// Arithmetic operation
`define movsgpr         5'b00000
`define mov             5'b00001
`define add             5'b00010
`define sub             5'b00011
`define mul             5'b00100

//////////////// Logical Operations
`define ror             5'b00101
`define rand            5'b00110
`define rxor            5'b00111
`define rxnor           5'b01000
`define rnand           5'b01001
`define rnor            5'b01010
`define rnot            5'b01011


module top();






reg [31:0] IR;            ////// instruction register  <--ir[31:27]--><--ir[26:22]--><--ir[21:17]--><--ir[16]--><--ir[15:11]--><--ir[10:0]-->
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  rsrc2 --><--unused  -->             
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_date      -->      

reg [15:0] GPR [31:0] ;   ///////general purpose register gpr[0] ....... gpr[31]



reg [15:0] SGPR ;      ///// msb of multiplication --> special register

reg [31:0] mul_res;



always@(*)
begin
case(`oper_type)
///////////////////////////////
`movsgpr: begin

   GPR[`rdst] = SGPR;
   
end

/////////////////////////////////
`mov : begin
   if(`imm_mode)
        GPR[`rdst]  = `isrc;
   else
       GPR[`rdst]   = GPR[`rsrc1];
end

////////////////////////////////////////////////////

`add : begin
      if(`imm_mode)
        GPR[`rdst]   = GPR[`rsrc1] + `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] + GPR[`rsrc2];
end

/////////////////////////////////////////////////////////

`sub : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] - `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] - GPR[`rsrc2];
end

/////////////////////////////////////////////////////////////

`mul : begin
      if(`imm_mode)
        mul_res   = GPR[`rsrc1] * `isrc;
     else
        mul_res   = GPR[`rsrc1] * GPR[`rsrc2];
        
     GPR[`rdst]   =  mul_res[15:0];
     SGPR         =  mul_res[31:16];
end

/////////////////////////////////////////////////////////////

`ror : begin
    if(`imm_mode)
        GPR[`rdst] = GPR[`rsrc1] | `isrc;
     else
        GPR[`rdst] = GPR[`rsrc1] | GPR[`rsrc2];

end
/////////////////////////////////////////////////////////////
`rand : begin

    if(`imm_mode)
        GPR[`rdst] = GPR[`rsrc1] & `isrc;
    else
        GPR[`rdst] = GPR[`rsrc1] & GPR[`rsrc2];
        
end

/////////////////////////////////////////////////////////////

`rxor : begin

    if(`imm_mode)
    
        GPR[`rdst] = GPR[`rsrc1] ^ `isrc;
    
    else
        
        GPR[`rdst] = GPR[`rsrc1] ^ GPR[`rsrc2];
        
end

//////////////////////////////////////////////////////////////

`rxnor : begin

    if(`imm_mode)
        
        GPR[`rdst] = GPR[`rsrc1] ~^ `isrc;
    
    else
        
        GPR[`rdst] = GPR[`rsrc1] ~^ GPR[`rsrc2];

end   
//////////////////////////////////////////////////////////////

`rnand : begin
    
    if (`imm_mode)
    
        GPR[`rdst] = ~(GPR[`rsrc1] & `isrc);
        
    else 
        
        GPR[`rdst] = ~(GPR[`rsrc1] & GPR[`rsrc2]);

end
//////////////////////////////////////////////////////////////

`rnor : begin

    if (`imm_mode)
    
        GPR[`rdst] = ~(GPR[`rsrc1] | `isrc);
        
    else
    
        GPR[`rdst] = ~(GPR[`rsrc1] | GPR[`rsrc2]);
        
 end
//////////////////////////////////////////////////////////////

`rnot : begin

    if (`imm_mode)
    
        GPR[`rdst] = ~(`isrc);
        
    else 
    
        GPR[`rdst] = ~(GPR[`rsrc1]);
        
end

//////////////////////////////////////////////////////////////
endcase
end
////////////////////////////////////////////////////////////////////////////

reg sign = 0, zero = 0, overflow = 0, carry  = 0;
reg [16:0] temp_sum;

always@(*)
begin

//////////////////sign flag

if (`oper_type == `mul)
    sign = SGPR[15]; // MSB of Multiplication Operation
else 
    sign = GPR[`rdst][15]; // Add or Sub Operation

//////////////////carry flag

if (`oper_type == `add)
    begin
        if (`imm_mode)
            begin
                temp_sum    = GPR[`rsrc1] + `isrc;
                carry       = temp_sum[16];
            end
        else
            begin
            temp_sum    = GPR[`rsrc1] + GPR[`rsrc2];
            carry       = temp_sum[16];
            end
     end
else

    begin
        carry = 1'b0; 
    end
    
//////////////////zero flag
 
if (`oper_type == `mul)

    zero = ~((| SGPR[15]) | (| GPR[`rdst]));

else
    zero = ~(| GPR[`rdst]);
    
//////////////////overflow flag        
    
if (`oper_type == `add)

    begin
        if(`imm_mode)
            overflow = ( (~GPR[`rsrc1][15]) & ~IR[15] & (GPR[`rdst][15]) | (GPR[`rsrc1][15]) & IR[15] & (~GPR[`rdst][15]) );
        else
            overflow = ( (~GPR[`rsrc1][15]) & ~GPR[`rsrc2][15] & (GPR[`rdst][15]) | (GPR[`rsrc1][15]) & GPR[`rsrc2][15] & (~GPR[`rdst][15]) );
    end
    
else if(`oper_type == `sub)

    begin
    
        if(`imm_mode)
            overflow = ( ( (~GPR[`rsrc1][15]) & IR[15] & (GPR[`rdst][15]) ) | ( (GPR[`rsrc1][15] & ~IR[15] & (~GPR[`rdst][15])) ) );
        else
            overflow = ( ( (~GPR[`rsrc1][15]) & GPR[`rsrc2][15] & (GPR[`rdst][15]) ) | ( (GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & (~GPR[`rdst][15])) ) );
    end

else

    begin
    overflow = 1'b0;
    end

  
    
    
////////////////////////////////////////////////////////////////////////////
 
end



endmodule

////////////////////////////////////////////////////////////////////////////
