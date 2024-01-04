`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:24 01/04/2024 
// Design Name: 
// Module Name:    random 
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
module random(
    input clk,
    input rst,
    input wire up,
    input wire down,
    input wire left,
    input wire right,
    //input wire key,
    input [63:0] input_val,
    output reg [63:0] output_val,
    output reg waiting
    );

    reg [2:0] cnt_btn;
    parameter max=3'd2;
    reg gen;
    reg [7:0] state;
    reg [15:0] cnt;

    wire [3:0] position;
    wire [3:0] val;
    assign val=cnt[3:0]<12?4'd1:4'd2;
    
    assign position[3]=state[1:0]==2'd0 ? cnt[3]:state[1:0]==2'd1 ? cnt[7]:state[1:0]==2'd2 ? cnt[11]:cnt[15];
    assign position[2]=state[1:0]==2'd0 ? cnt[2]:state[1:0]==2'd1 ? cnt[6]:state[1:0]==2'd2 ? cnt[10]:cnt[14];
    assign position[1]=state[1:0]==2'd0 ? cnt[1]:state[1:0]==2'd1 ? cnt[5]:state[1:0]==2'd2 ? cnt[9]:cnt[13];
    assign position[0]=state[1:0]==2'd0 ? cnt[0]:state[1:0]==2'd1 ? cnt[4]:state[1:0]==2'd2 ? cnt[8]:cnt[12];

    always @(posedge clk) begin
        if(rst) begin
            cnt<=16'd0;
            state<=8'd0;
            waiting<=1;
            output_val<=input_val;
        end
        else if(gen) begin
            cnt<=cnt+1;
            state<=state+1;
            waiting<=1;
            output_val<=input_val;
        end
        else begin
            cnt<=cnt+1;
            state<=state;
            if(waiting) begin
                if(((input_val>>(4*position))&4'b1111)==4'd0) begin
                    output_val<=input_val | ({60'd0,val} << (4*position));
                    waiting<=0;
                end
                else begin
                    waiting<=1;
                    output_val<=input_val;
                end
            end
            else begin
                waiting<=0;
                output_val<=input_val;
            end
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            gen<=0;
            cnt_btn<=3'd0;
        end
        //else if (key==4'b0001||key==4'b0010||key==4'b0100||key==4'b1000) begin
        else if (up|down|left|right) begin
            if(cnt_btn>=max) begin
                gen<=1;
                cnt_btn<=3'd0;
            end
            else begin
                cnt_btn<=cnt_btn+3'd1;
                gen<=0;
            end
        end
        else begin
            cnt_btn<=cnt_btn;
            gen<=0;
        end
    end
endmodule
