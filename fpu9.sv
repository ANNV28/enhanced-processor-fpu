module fpu9 (
 input logic [8:0] A,
 input logic [8:0] B,
 input logic AddSubF,
 output logic [8:0] Result,
 output logic Z
);

 logic sign_A, sign_B, sign_B_eff;
 logic [3:0] exp_A, exp_B;
 logic [3:0] frac_A, frac_B;
 logic [4:0] mant_A, mant_B;
 logic [4:0] mant_big, mant_small;
 logic [3:0] exp_big;
 logic sign_big, sign_small;
 logic [3:0] exp_diff;
 logic [4:0] mant_small_shifted;
 logic same_sign;
 logic [5:0] mant_sum;
 logic [5:0] mant_mag;
 logic result_sign;
 logic [3:0] norm_exp;
 logic [4:0] norm_mant;
 logic [3:0] final_frac;

 assign sign_A = A[8];
 assign sign_B = B[8];
 assign exp_A = A[7:4];
 assign exp_B = B[7:4];
 assign frac_A = A[3:0];
 assign frac_B = B[3:0];

 assign sign_B_eff = sign_B ^ AddSubF;

 assign mant_A = (exp_A == 4'd0) ? 5'b00000 : {1'b1, frac_A};
 assign mant_B = (exp_B == 4'd0) ? 5'b00000 : {1'b1, frac_B};

 always_comb begin
 mant_big = mant_A;
 mant_small = mant_B;
 exp_big = exp_A;
 sign_big = sign_A;
 sign_small = sign_B_eff;
 exp_diff = 4'd0;

 if (exp_A > exp_B) begin
 mant_big = mant_A;
 mant_small = mant_B;
 exp_big = exp_A;
 sign_big = sign_A;
 sign_small = sign_B_eff;
 exp_diff = exp_A - exp_B;
 end
 else if (exp_B > exp_A) begin
 mant_big = mant_B;
 mant_small = mant_A;
 exp_big = exp_B;
 sign_big = sign_B_eff;
 sign_small = sign_A;
 exp_diff = exp_B - exp_A;
 end
 else begin
 exp_big = exp_A;
 exp_diff = 4'd0;
 if (mant_A >= mant_B) begin
 mant_big = mant_A;
 mant_small = mant_B;
 sign_big = sign_A;
 sign_small = sign_B_eff;
 end
 else begin
 mant_big = mant_B;
 mant_small = mant_A;
 sign_big = sign_B_eff;
 sign_small = sign_A;
 end
 end
 end

 always_comb begin
 if (exp_diff >= 4'd5)
 mant_small_shifted = 5'b00000;
 else
 mant_small_shifted = mant_small >> exp_diff;
 end

 assign same_sign = (sign_big == sign_small);

 always_comb begin
 mant_sum = 6'b000000;
 mant_mag = 6'b000000;
 result_sign = sign_big;

 if (same_sign) begin
 mant_sum = {1'b0, mant_big} + {1'b0, mant_small_shifted};
 mant_mag = mant_sum;
 result_sign = sign_big;
 end
 else begin
 mant_mag = {1'b0, mant_big} - {1'b0, mant_small_shifted};
 result_sign = sign_big;
 end
 end

 always_comb begin
 norm_exp = exp_big;
 norm_mant = mant_mag[4:0];

 if (mant_mag == 6'b000000) begin
 norm_exp = 4'd0;
 norm_mant = 5'b00000;
 end
 else if (mant_mag[5] == 1'b1) begin
 norm_mant = mant_mag[5:1];
 norm_exp = exp_big + 4'd1;
 end
 else begin
 norm_mant = mant_mag[4:0];

 if (norm_mant[4] == 1'b0 && norm_exp > 4'd0) begin
 norm_mant = norm_mant << 1;
 norm_exp = norm_exp - 4'd1;
 end

 if (norm_mant[4] == 1'b0 && norm_exp > 4'd0) begin
 norm_mant = norm_mant << 1;
 norm_exp = norm_exp - 4'd1;
 end

 if (norm_mant[4] == 1'b0 && norm_exp > 4'd0) begin
 norm_mant = norm_mant << 1;
 norm_exp = norm_exp - 4'd1;
 end

 if (norm_mant[4] == 1'b0 && norm_exp > 4'd0) begin
 norm_mant = norm_mant << 1;
 norm_exp = norm_exp - 4'd1;
 end
 end
 end

 assign final_frac = norm_mant[3:0];

 always_comb begin
 if (mant_mag == 6'b000000) begin
 Result = 9'b000000000;
 Z = 1'b1;
 end
 else begin
 Result = {result_sign, norm_exp, final_frac};
 Z = 1'b0;
 end
 end

endmodule