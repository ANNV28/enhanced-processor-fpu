module register9bit (
input logic clk,
input logic rst,
input logic en,
input logic [8:0] d,
output logic [8:0] q); 

d_ff ff0(.clk(clk),.rst(rst),.en(en),.d(d[0]),.q(q[0]));
d_ff ff1(.clk(clk),.rst(rst),.en(en),.d(d[1]),.q(q[1]));
d_ff ff2(.clk(clk),.rst(rst),.en(en),.d(d[2]),.q(q[2]));
d_ff ff3(.clk(clk),.rst(rst),.en(en),.d(d[3]),.q(q[3]));
d_ff ff4(.clk(clk),.rst(rst),.en(en),.d(d[4]),.q(q[4]));
d_ff ff5(.clk(clk),.rst(rst),.en(en),.d(d[5]),.q(q[5]));
d_ff ff6(.clk(clk),.rst(rst),.en(en),.d(d[6]),.q(q[6]));
d_ff ff7(.clk(clk),.rst(rst),.en(en),.d(d[7]),.q(q[7]));
d_ff ff8(.clk(clk),.rst(rst),.en(en),.d(d[8]),.q(q[8]));

endmodule 

module d_ff(
input logic d,
input logic clk, 
input logic rst, 
input logic en,
output logic q);

always_ff @(posedge clk) begin 
if (!rst) begin 
q <= 0; 
end 
else if (en) begin 
q <= d; 
end 
end 

endmodule