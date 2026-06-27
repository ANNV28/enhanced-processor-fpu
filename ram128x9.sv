module ram128x9 (
 input logic clk,
 input logic [6:0] addr,
 input logic [8:0] data,
 input logic wren,
 output logic [8:0] q
);
 logic [8:0] mem [0:127];

 initial begin
 $readmemb("lab6.mif", mem);
 end

 always_ff @(posedge clk) begin
 if (wren)
 mem[addr] <= data;
 end

 assign q = mem[addr];

endmodule