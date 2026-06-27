module enhanced_processor(
 input logic clk,
 input logic Run,
 input logic Resetn,
 input logic [8:0] DIN,
 output logic [8:0] Bus,
 output logic [8:0] ADDR,
 output logic [8:0] DOUT,
 output logic W,
 output logic R0in,R1in,R2in,R3in,R4in,R5in,R6in,R7in,
 output logic Ain,Gin,IRin,ADDRin,DOUTin,
 output logic AFin,GFin,
 output logic AddSub,AddSubF,
 output logic Gout,GFout,DINout,incr_PC,
 output logic [2:0] RoutSel,
 output logic Done
);

logic [8:0] bus_prior;
logic [8:0] R0, R1, R2, R3, R4, R5, R6, R7;
logic [8:0] A, G, IR;
logic [8:0] AF, GF;
logic [8:0] mux_out;
logic [8:0] alu_out;
logic [8:0] fpu_out;
logic alu_cout;
logic [8:0] ADDR_reg, DOUT_reg;
logic [2:0] state, next_state;
logic [2:0] opcode, Rx, Ry;

localparam T0 = 3'b000,
 T1 = 3'b001,
 T2 = 3'b010,
 T3 = 3'b011,
 T4 = 3'b100;

localparam MV = 3'b000,
 MVI = 3'b001,
 ADD = 3'b010,
 SUB = 3'b011,
 LD = 3'b100,
 ST = 3'b101,
 MVNZ = 3'b110,
 ADDF = 3'b111;

assign opcode = IR[8:6];
assign Rx = IR[5:3];
assign Ry = IR[2:0];

always_ff @(posedge clk) begin
 if (!Resetn)
 state <= T0;
 else
 state <= next_state;
end

always_comb begin
 R0in = 1'b0;
 R1in = 1'b0;
 R2in = 1'b0;
 R3in = 1'b0;
 R4in = 1'b0;
 R5in = 1'b0;
 R6in = 1'b0;
 R7in = 1'b0;
 Ain = 1'b0;
 Gin = 1'b0;
 AFin = 1'b0;
 GFin = 1'b0;
 IRin = 1'b0;
 ADDRin = 1'b0;
 DOUTin = 1'b0;
 AddSub = 1'b0;
 AddSubF = 1'b0;
 Gout = 1'b0;
 GFout = 1'b0;
 DINout = 1'b0;
 incr_PC = 1'b0;
 W = 1'b0;
 Done = 1'b0;
 RoutSel = 3'b000;
 next_state = state;

 case (state)

 T0: begin
 if (Run) begin
 RoutSel = 3'b111;
 ADDRin = 1'b1;
 next_state = T4;
 end
 else begin
 next_state = T0;
 end
 end

 T4: begin
 IRin = 1'b1;
 incr_PC = 1'b1;
 next_state = T1;
 end

 T1: begin
 case (opcode)
 MV: begin
 RoutSel = Ry;
 Done = 1'b1;
 next_state = T0;
 case (Rx)
 3'd0: R0in = 1'b1;
 3'd1: R1in = 1'b1;
 3'd2: R2in = 1'b1;
 3'd3: R3in = 1'b1;
 3'd4: R4in = 1'b1;
 3'd5: R5in = 1'b1;
 3'd6: R6in = 1'b1;
 3'd7: R7in = 1'b1;
 endcase
 end

 MVI: begin
 RoutSel = 3'b111;
 ADDRin = 1'b1;
 next_state = T2;
 end

 ADD, SUB: begin
 RoutSel = Rx;
 Ain = 1'b1;
 next_state = T2;
 end

 ADDF: begin
 RoutSel = Rx;
 AFin = 1'b1;
 next_state = T2;
 end

 LD: begin
 RoutSel = Ry;
 ADDRin = 1'b1;
 next_state = T2;
 end

 ST: begin
 RoutSel = Ry;
 ADDRin = 1'b1;
 next_state = T2;
 end

 MVNZ: begin
 if (G != 9'd0) begin
 RoutSel = Ry;
 case (Rx)
 3'd0: R0in = 1'b1;
 3'd1: R1in = 1'b1;
 3'd2: R2in = 1'b1;
 3'd3: R3in = 1'b1;
 3'd4: R4in = 1'b1;
 3'd5: R5in = 1'b1;
 3'd6: R6in = 1'b1;
 3'd7: R7in = 1'b1;
 endcase
 end
 Done = 1'b1;
 next_state = T0;
 end

 default: begin
 Done = 1'b1;
 next_state = T0;
 end
 endcase
 end

 T2: begin
 case (opcode)

 MVI: begin
 DINout = 1'b1;
 incr_PC = 1'b1;
 Done = 1'b1;
 next_state = T0;
 case (Rx)
 3'd0: R0in = 1'b1;
 3'd1: R1in = 1'b1;
 3'd2: R2in = 1'b1;
 3'd3: R3in = 1'b1;
 3'd4: R4in = 1'b1;
 3'd5: R5in = 1'b1;
 3'd6: R6in = 1'b1;
 3'd7: R7in = 1'b1;
 endcase
 end

 ADD: begin
 RoutSel = Ry;
 Gin = 1'b1;
 AddSub = 1'b0;
 next_state = T3;
 end

 SUB: begin
 RoutSel = Ry;
 Gin = 1'b1;
 AddSub = 1'b1;
 next_state = T3;
 end

 ADDF: begin
 RoutSel = Ry;
 GFin = 1'b1;
 AddSubF = 1'b0;
 next_state = T3;
 end

 LD: begin
 DINout = 1'b1;
 Done = 1'b1;
 next_state = T0;
 case (Rx)
 3'd0: R0in = 1'b1;
 3'd1: R1in = 1'b1;
 3'd2: R2in = 1'b1;
 3'd3: R3in = 1'b1;
 3'd4: R4in = 1'b1;
 3'd5: R5in = 1'b1;
 3'd6: R6in = 1'b1;
 3'd7: R7in = 1'b1;
 endcase
 end

 ST: begin
 RoutSel = Rx;
 DOUTin = 1'b1;
 next_state = T3;
 end

 default: begin
 Done = 1'b1;
 next_state = T0;
 end
 endcase
 end

 T3: begin
 case (opcode)

 ADD, SUB: begin
 Gout = 1'b1;
 Done = 1'b1;
 next_state = T0;
 case (Rx)
 3'd0: R0in = 1'b1;
 3'd1: R1in = 1'b1;
 3'd2: R2in = 1'b1;
 3'd3: R3in = 1'b1;
 3'd4: R4in = 1'b1;
 3'd5: R5in = 1'b1;
 3'd6: R6in = 1'b1;
 3'd7: R7in = 1'b1;
 endcase
 end

 ADDF: begin
 GFout = 1'b1;
 Done = 1'b1;
 next_state = T0;
 case (Rx)
 3'd0: R0in = 1'b1;
 3'd1: R1in = 1'b1;
 3'd2: R2in = 1'b1;
 3'd3: R3in = 1'b1;
 3'd4: R4in = 1'b1;
 3'd5: R5in = 1'b1;
 3'd6: R6in = 1'b1;
 3'd7: R7in = 1'b1;
 endcase
 end

 ST: begin
 W = 1'b1;
 Done = 1'b1;
 next_state = T0;
 end

 default: begin
 Done = 1'b1;
 next_state = T0;
 end
 endcase
 end

 default: begin
 next_state = T0;
 end

 endcase
end

register9bit reg0(.clk(clk),.rst(Resetn),.en(R0in),.d(Bus),.q(R0));
register9bit reg1(.clk(clk),.rst(Resetn),.en(R1in),.d(Bus),.q(R1));
register9bit reg2(.clk(clk),.rst(Resetn),.en(R2in),.d(Bus),.q(R2));
register9bit reg3(.clk(clk),.rst(Resetn),.en(R3in),.d(Bus),.q(R3));
register9bit reg4(.clk(clk),.rst(Resetn),.en(R4in),.d(Bus),.q(R4));
register9bit reg5(.clk(clk),.rst(Resetn),.en(R5in),.d(Bus),.q(R5));
register9bit reg6(.clk(clk),.rst(Resetn),.en(R6in),.d(Bus),.q(R6));

pc_reg reg7(.clk(clk),.rst(Resetn),.en(R7in),.incr_pc(incr_PC),.d(Bus),.q(R7));

register9bit regA (.clk(clk),.rst(Resetn),.en(Ain), .d(Bus), .q(A));
register9bit regG (.clk(clk),.rst(Resetn),.en(Gin), .d(alu_out),.q(G));
register9bit regAF (.clk(clk),.rst(Resetn),.en(AFin), .d(Bus), .q(AF));
register9bit regGF (.clk(clk),.rst(Resetn),.en(GFin), .d(fpu_out),.q(GF));
register9bit regIR (.clk(clk),.rst(Resetn),.en(IRin), .d(DIN), .q(IR));
register9bit regADR (.clk(clk),.rst(Resetn),.en(ADDRin),.d(Bus), .q(ADDR_reg));
register9bit regDO (.clk(clk),.rst(Resetn),.en(DOUTin),.d(Bus), .q(DOUT_reg));

assign ADDR = ADDR_reg;
assign DOUT = DOUT_reg;

mux8to1_9bit imux(
 .i0(R0),.i1(R1),.i2(R2),.i3(R3),
 .i4(R4),.i5(R5),.i6(R6),.i7(R7),
 .sel(RoutSel),
 .y(mux_out)
);

addsub9bit ialu(
 .A(A),
 .B(Bus),
 .Sel(AddSub),
 .S(alu_out),
 .Cout(alu_cout)
);

logic fpu_z;

fpu9 ifpu(
 .A(AF),
 .B(Bus),
 .AddSubF(AddSubF),
 .Result(fpu_out),
 .Z(fpu_z)
);

assign bus_prior = DINout ? DIN : mux_out;

assign Bus = Gout ? G :
 GFout ? GF :
 bus_prior;

endmodule