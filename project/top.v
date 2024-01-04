module top(
    input wire clk,
    input wire ps2_clk,
    input wire ps2_data,
    // input wire BTN_RIGHT,   //right-most pushbutton
    // input wire BTN_LEFT,    //left-most pushbutton
    // input wire BTN_TOP,     //top-most pushbutton
    // input wire BTN_BOT,
    output wire [6:0] C,
    output wire [3:0] A,
    output wire [2:0] red,
    output wire [2:0] green,
    output wire [1:0] blue,
    output wire hsync,
    output wire vsync
    );

    wire segclk;
    wire dclk;
    wire rst,RST;
    wire gen_rand, gen_active, game_over, move_en;
    wire BTN_BOT, BTN_TOP, BTN_LEFT, BTN_RIGHT;
    assign move_en = ~gen_active & ~game_over;
    wire btn_bot, btn_top, btn_left, btn_right;

    wire [63:0] moved_vals, tilevals;
    wire [15:0] score;
    wire [3:0] score1, score10, score100, score1000; 
    assign score1 = score % 10;
    assign score10 = score > 9  ? (score % 100) / 10 : 4'b1111;
    assign score100 = score > 99  ? (score % 1000) / 100 : 4'b1111;
    assign score1000 = score > 999  ? (score % 10000) / 1000 : 4'b1111;

    mykeyboard kbd(
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .BTN_BOT(BTN_BOT),
        .BTN_TOP(BTN_TOP),
        .BTN_LEFT(BTN_LEFT),
        .BTN_RIGHT(BTN_RIGHT),
        .RST(RST)
    );

    button b1(
        .clk(clk),
        .btn(RST),
        .out(rst)
    );
    
    button b2(
        .clk(clk),
        .btn(BTN_RIGHT),
        .out(btn_right)
    );
    
    button b3(
        .clk(clk),
        .btn(BTN_LEFT),
        .out(btn_left)
    );
    
    button b4(
        .clk(clk),
        .btn(BTN_TOP),
        .out(btn_top)
    );
    
    button b5(
        .clk(clk),
        .btn(BTN_BOT),
        .out(btn_bot)
    );

    

    disp_clkdiv U1(
        .clk(clk),
        .clr(rst),
        .segclk(segclk),
        .dclk(dclk)
    );

    move U2(
        .up(btn_top),
	    .down(btn_bot),
        .left(btn_left),
        .right(btn_right),
        .rst(rst),
        .enable(move_en),
        .input_tile_val(tilevals),
        .output_tile_val(moved_vals)
	);

    random U3(
        .clk(clk),
        .rst(rst),
        .up(btn_top),
	    .down(btn_bot),
        .left(btn_left),
        .right(btn_right),
        .input_val(moved_vals),
        .output_val(tilevals),
        .waiting(gen_active)
    );

    segdisplay U4(
        .clk(clk),
        .mux_clk(segclk),
        .rst(rst),
        .val1(score1000),
        .val2(score100),
        .val3(score10),
        .val4(score1),
        .C(C),
        .A(A)
    );

    displaygrid U5(
        .dclk(dclk),
        .clr(rst),
        .vals(tilevals),	
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    state U6(
        .tiles(tilevals),
        .score(score),
        .isover(game_over)
    );

endmodule