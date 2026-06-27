module pc_reg(
 input logic clk,
 input logic rst,
 input logic en,
 input logic incr_pc,
 input logic [8:0] d,
 output logic [8:0] q
);

always_ff @(posedge clk) begin
 if (!rst)
 q <= 9'd0;
 else if (en)
 q <= d;
 else if (incr_pc)
 q <= q + 9'd1;
end

endmodule