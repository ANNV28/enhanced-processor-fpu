module mux8to1_9bit( 
input logic [8:0] i0,i1,i2,i3,i4,i5,i6,i7,
input logic [2:0] sel,
output logic [8:0] y);

logic [8:0] y0,y1,y2,y3,y4,y5;

mux2to1_9bit mux0(.i0(i0),.i1(i1),.sel(sel[0]),.y(y0));
mux2to1_9bit mux1(.i0(i2),.i1(i3),.sel(sel[0]),.y(y1));
mux2to1_9bit mux2(.i0(i4),.i1(i5),.sel(sel[0]),.y(y2));
mux2to1_9bit mux3(.i0(i6),.i1(i7),.sel(sel[0]),.y(y3));
mux2to1_9bit mux4(.i0(y0),.i1(y1),.sel(sel[1]),.y(y4));
mux2to1_9bit mux5(.i0(y2),.i1(y3),.sel(sel[1]),.y(y5));
mux2to1_9bit mux6(.i0(y4),.i1(y5),.sel(sel[2]),.y(y));

endmodule 

module mux2to1_9bit (
 input logic [8:0] i0, i1,
 input logic sel,
 output logic [8:0] y
);

assign y = sel ? i1 : i0;

endmodule