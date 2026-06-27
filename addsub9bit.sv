module addsub9bit (
input logic [8:0] A,B,
input logic Sel, 
output logic [8:0] S, 
output logic Cout);

logic c0,c1,c2,c3,c4,c5,c6,c7;
logic [8:0] B_xor; 

assign B_xor[0] = B[0] ^ Sel; 
assign B_xor[1] = B[1] ^ Sel; 
assign B_xor[2] = B[2] ^ Sel; 
assign B_xor[3] = B[3] ^ Sel; 
assign B_xor[4] = B[4] ^ Sel; 
assign B_xor[5] = B[5] ^ Sel; 
assign B_xor[6] = B[6] ^ Sel; 
assign B_xor[7] = B[7] ^ Sel; 
assign B_xor[8] = B[8] ^ Sel;

fa1bit fa0(.a(A[0]),.b(B_xor[0]),.cin(Sel),.s(S[0]),.cout(c0));
fa1bit fa1(.a(A[1]),.b(B_xor[1]),.cin(c0),.s(S[1]),.cout(c1));
fa1bit fa2(.a(A[2]),.b(B_xor[2]),.cin(c1),.s(S[2]),.cout(c2));
fa1bit fa3(.a(A[3]),.b(B_xor[3]),.cin(c2),.s(S[3]),.cout(c3));
fa1bit fa4(.a(A[4]),.b(B_xor[4]),.cin(c3),.s(S[4]),.cout(c4));
fa1bit fa5(.a(A[5]),.b(B_xor[5]),.cin(c4),.s(S[5]),.cout(c5));
fa1bit fa6(.a(A[6]),.b(B_xor[6]),.cin(c5),.s(S[6]),.cout(c6));
fa1bit fa7(.a(A[7]),.b(B_xor[7]),.cin(c6),.s(S[7]),.cout(c7));
fa1bit fa8(.a(A[8]),.b(B_xor[8]),.cin(c7),.s(S[8]),.cout(Cout));

endmodule 

module fa1bit (
input logic a,b,cin, 
output logic s,cout);

assign s = a ^ b ^ cin;
assign cout = (a&b) | (a&cin) | (b&cin);

endmodule