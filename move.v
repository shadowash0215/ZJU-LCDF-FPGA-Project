`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:33 01/04/2024 
// Design Name: 
// Module Name:    move 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This module simulates the movement logic of the 2048 game. It takes input tile values representing the current state of the
//              game, processes movement (up,down,left,right), and updates the game state in tilevalues. The resulting game state is stored in output tile values.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module move(
    input wire rst,
    input wire enable,
    input wire up,
    input wire down,
    input wire left,
    input wire right,
    //input wire key,
    input wire [63:0] input_tile_val,
    output reg [63:0] output_tile_val
    );

    integer i;
    integer j;
    reg [3:0] tilevals [0:3][0:3];

    //Assign input tile values to the 4x4 array
    always @(*) begin
        tilevals[0][0] = input_tile_val[63:60];   
        tilevals[0][1] = input_tile_val[59:56];
        tilevals[0][2] = input_tile_val[55:52];
        tilevals[0][3] = input_tile_val[51:48];
        tilevals[1][0] = input_tile_val[47:44]; 
        tilevals[1][1] = input_tile_val[43:40];
        tilevals[1][2] = input_tile_val[39:36];
        tilevals[1][3] = input_tile_val[35:32];
        tilevals[2][0] = input_tile_val[31:28];
        tilevals[2][1] = input_tile_val[27:24];
        tilevals[2][2] = input_tile_val[23:20];
        tilevals[2][3] = input_tile_val[19:16];
        tilevals[3][0] = input_tile_val[15:12];
        tilevals[3][1] = input_tile_val[11:8];
        tilevals[3][2] = input_tile_val[7:4];
        tilevals[3][3] = input_tile_val[3:0];

        //Reset the game state when rst is asserted
        if(rst) begin
            for(i=0;i<4;i=i+1)begin
                for(j=0;j<4;j=j+1)begin
                    tilevals[i][j]=4'd0;
                end
            end
        end
        //Process down movement command
        else if (down) begin
            for(i=0;i<4;i=i+1) begin
                if(tilevals[0][i]==4'd0) begin
                    tilevals[0][i]=tilevals[1][i];
                    tilevals[1][i]=tilevals[2][i];
                    tilevals[2][i]=tilevals[3][i];
                    tilevals[3][i]=4'd0;
                end
                else if (tilevals[0][i]==tilevals[1][i])begin
                    tilevals[0][i]=tilevals[0][i]+4'd1;
                    tilevals[1][i]=tilevals[2][i];
                    tilevals[2][i]=tilevals[3][i];
                    tilevals[3][i]=4'd0;
                end
                else begin
                    if(tilevals[1][i]==4'd0)begin
                        tilevals[1][i]=tilevals[2][i];
                        tilevals[2][i]=tilevals[3][i];
                        tilevals[3][i]=4'd0;
                    end
                    else if (tilevals[1][i]==tilevals[2][i])begin
                        tilevals[1][i]=tilevals[1][i]+4'd1;
                        tilevals[2][i]=tilevals[3][i];
                        tilevals[3][i]=4'd0;
                    end
                    else begin
                        if(tilevals[2][i]==4'd0)begin
                            tilevals[2][i]=tilevals[3][i];
                            tilevals[3][i]=4'd0;
                        end
                        else if (tilevals[2][i]==tilevals[3][i]) begin
                            tilevals[2][i]=tilevals[2][i]+4'd1;
                            tilevals[3][i]=4'd0;
                        end
                    end
                end
            end
        end
        //Process up momvement command
        else if (up) begin
            for(i=0; i<4; i=i+1) begin
                if (tilevals[3][i] == 4'd0) begin
                    tilevals[3][i] = tilevals[2][i];
                    tilevals[2][i] = tilevals[1][i];
                    tilevals[1][i] = tilevals[0][i];
                    tilevals[0][i] = 4'd0;
                end
                else if (tilevals[3][i] == tilevals[2][i]) begin
                    tilevals[3][i] = tilevals[3][i] + 4'd1;
                    tilevals[2][i] = tilevals[1][i];
                    tilevals[1][i] = tilevals[0][i];
                    tilevals[0][i] = 4'd0;
                end
                else begin
                    if (tilevals[2][i] == 4'd0) begin
                        tilevals[2][i] = tilevals[1][i];
                        tilevals[1][i] = tilevals[0][i];
                        tilevals[0][i] = 4'd0;
                    end
                    else if (tilevals[2][i] == tilevals[1][i]) begin
                        tilevals[2][i] = tilevals[2][i] + 4'd1;
                        tilevals[1][i] = tilevals[0][i];
                        tilevals[0][i] = 4'd0;
                    end
                    else begin
                        if (tilevals[1][i] == 4'd0) begin
                            tilevals[1][i] = tilevals[0][i];
                            tilevals[0][i] = 4'd0;
                        end
                        else if (tilevals[1][i] == tilevals[0][i]) begin
                            tilevals[1][i]=tilevals[1][i]+4'd1;
                            tilevals[0][i]=4'd0;
                        end
                    end
                end
            end
        end 
        //Process left movement command
        else if (left) begin
            for(i=0; i<4; i=i+1) begin
                if (tilevals[i][3]==4'd0) begin
                    tilevals[i][3]=tilevals[i][2];
                    tilevals[i][2]=tilevals[i][1];
                    tilevals[i][1]=tilevals[i][0];
                    tilevals[i][0]=4'd0;
                end
                else if (tilevals[i][3] == tilevals[i][2]) begin
                    tilevals[i][3]=tilevals[i][3]+4'd1;
                    tilevals[i][2]=tilevals[i][1];
                    tilevals[i][1]=tilevals[i][0];
                    tilevals[i][0]=4'd0;
                end
                else begin  
                    if (tilevals[i][2]== 4'd0) begin
                        tilevals[i][2]=tilevals[i][1];
                        tilevals[i][1]=tilevals[i][0];
                        tilevals[i][0]=4'd0;
                    end
                    else if (tilevals[i][2]== tilevals[i][1]) begin
                        tilevals[i][2]=tilevals[i][2]+4'd1;
                        tilevals[i][1]=tilevals[i][0];
                        tilevals[i][0]=4'd0;
                    end
                    else begin  
                        if (tilevals[i][1]==4'd0) begin
                            tilevals[i][1]=tilevals[i][0];
                            tilevals[i][0]=4'd0;
                        end
                        else if (tilevals[i][1]==tilevals[i][0]) begin
                            tilevals[i][1]=tilevals[i][1]+4'd1;
                            tilevals[i][0]=4'd0;
                        end
                    end
                end
            end
        end 
        //Process right movement command
        else if (right) begin
            for(i=0; i<4; i=i+1) begin  
                if (tilevals[i][0]==4'd0) begin
                    tilevals[i][0]=tilevals[i][1];
                    tilevals[i][1]=tilevals[i][2];
                    tilevals[i][2]=tilevals[i][3];
                    tilevals[i][3]=4'd0;
                end
                else if (tilevals[i][0]==tilevals[i][1]) begin
                    tilevals[i][0]=tilevals[i][0] + 4'd1;
                    tilevals[i][1]=tilevals[i][2];
                    tilevals[i][2]=tilevals[i][3];
                    tilevals[i][3]=4'd0;
                end
                else begin  
                    if (tilevals[i][1]==4'd0) begin
                        tilevals[i][1]=tilevals[i][2];
                        tilevals[i][2]=tilevals[i][3];
                        tilevals[i][3]=4'd0;
                    end
                    else if (tilevals[i][1]==tilevals[i][2]) begin
                        tilevals[i][1]=tilevals[i][1] + 4'd1;
                        tilevals[i][2]=tilevals[i][3];
                        tilevals[i][3]=4'd0;
                    end
                    else begin  
                        if (tilevals[i][2]==4'd0) begin
                            tilevals[i][2]=tilevals[i][3];
                            tilevals[i][3]=4'd0;
                        end
                        else if (tilevals[i][2]==tilevals[i][3]) begin
                            tilevals[i][2]=tilevals[i][2]+4'd1;
                            tilevals[i][3]=4'd0;
                        end
                    end
                end
            end
        end

        //Update output tile values based on the resulting game state in tile values
        output_tile_val[63:60] = tilevals[0][0];
        output_tile_val[59:56] = tilevals[0][1];
        output_tile_val[55:52] = tilevals[0][2];
        output_tile_val[51:48] = tilevals[0][3];
        output_tile_val[47:44] = tilevals[1][0];
        output_tile_val[43:40] = tilevals[1][1];
        output_tile_val[39:36] = tilevals[1][2];
        output_tile_val[35:32] = tilevals[1][3];
        output_tile_val[31:28] = tilevals[2][0];
        output_tile_val[27:24] = tilevals[2][1];
        output_tile_val[23:20] = tilevals[2][2];
        output_tile_val[19:16] = tilevals[2][3];
        output_tile_val[15:12] = tilevals[3][0];
        output_tile_val[11:8] = tilevals[3][1];
        output_tile_val[7:4] = tilevals[3][2];
        output_tile_val[3:0] = tilevals[3][3];

    end



endmodule
