`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:49 01/04/2024 
// Design Name: 
// Module Name:    state 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module state(
    input [63:0] tiles,
    output wire [15:0] score,
    output wire isover
    );

    wire full;
    wire is2048;
    wire row1, row2, row3, row4;
    wire col1, col2, col3, col4;

    assign full = |tiles[63:60] & |tiles[59:56] & |tiles[55:52] & |tiles[51:48] & |tiles[47:44] & |tiles[43:40] & |tiles[39:36] & |tiles[35:32] & |tiles[31:28] & |tiles[27:24] & |tiles[23:20] & |tiles[19:16] & |tiles[15:12] & |tiles[11:8] & |tiles[7:4] & |tiles[3:0];
    assign row1 = (tiles[63:60]==tiles[59:56]) || (tiles[59:56]==tiles[55:52]) || (tiles[55:52]==tiles[51:48]);
    assign row2 = (tiles[47:44]==tiles[43:40]) || (tiles[43:40]==tiles[39:36]) || (tiles[39:36]==tiles[35:32]);
    assign row3 = (tiles[31:28]==tiles[27:24]) || (tiles[27:24]==tiles[23:20]) || (tiles[23:20]==tiles[19:16]);
    assign row4 = (tiles[15:12]==tiles[11:8]) || (tiles[11:8]==tiles[7:4]) || (tiles[7:4]==tiles[3:0]);

    assign col1 = (tiles[63:60]==tiles[47:44]) || (tiles[47:44]==tiles[31:28]) || (tiles[31:28]==tiles[15:12]);
    assign col2 = (tiles[59:56]==tiles[43:40]) || (tiles[43:40]==tiles[27:24]) || (tiles[27:24]==tiles[11:8]);
    assign col3 = (tiles[55:52]==tiles[39:36]) || (tiles[39:36]==tiles[23:20]) || (tiles[23:20]==tiles[7:4]);
    assign col4 = (tiles[51:48]==tiles[35:32]) || (tiles[35:32]==tiles[19:16]) || (tiles[19:16]==tiles[3:0]);

    assign is2048 = tiles[63:60]==4'd11 || tiles[59:56]==4'd11 || tiles[55:52]==4'd11 || tiles[51:48]==4'd11 || tiles[47:44]==4'd11 || tiles[43:40]==4'd11 || tiles[39:36]==4'd11 || tiles[35:32]==4'd11 || tiles[31:28]==4'd11 || tiles[27:24]==4'd11 || tiles[23:20]==4'd11 || tiles[19:16]==4'd11 || tiles[15:12]==4'd11 || tiles[11:8]==4'd11 || tiles[7:4]==4'd11 || tiles[3:0]==4'd11;

    assign isover = (full && !row1 && !row2 && !row3 && !row4 && !col1 && !col2 && !col3 && !col4) || is2048;

    assign score = (tiles[63:60]==0?0:16'd1<<tiles[63:60])+(tiles[59:56]==0?0:16'd1<<tiles[59:56])+(tiles[55:52]==0?0:16'd1<<tiles[55:52])+(tiles[51:48]==0?0:16'd1<<tiles[51:48])+(tiles[47:44]==0?0:16'd1<<tiles[47:44])+(tiles[43:40]==0?0:16'd1<<tiles[43:40])+(tiles[39:36]==0?0:16'd1<<tiles[39:36])+(tiles[35:32]==0?0:16'd1<<tiles[35:32])+(tiles[31:28]==0?0:16'd1<<tiles[31:28])+(tiles[27:24]==0?0:16'd1<<tiles[27:24])+(tiles[23:20]==0?0:16'd1<<tiles[23:20])+(tiles[19:16]==0?0:16'd1<<tiles[19:16])+(tiles[15:12]==0?0:16'd1<<tiles[15:12])+(tiles[11:8]==0?0:16'd1<<tiles[11:8])+(tiles[7:4]==0?0:16'd1<<tiles[7:4])+(tiles[3:0]==0?0:16'd1<<tiles[3:0]);

endmodule
