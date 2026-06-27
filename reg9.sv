module reg9 (
 input logic clk,
 input logic rst,
 input logic en,
 input logic [8:0] d,
 output logic [8:0] q
);

always_ff @(posedge clk) begin
 if (!rst)
 q <= 9'b0;
 else if (en)
 q <= d;
end

endmodule