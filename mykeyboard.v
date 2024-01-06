//该模块定义了PS/2键盘输入功能，根据上下左右按键控制方块的移动，R按键重置游戏

module mykeyboard(
  input wire clk,
  input wire ps2_clk, //PS/2 clock input
  input wire ps2_data, //PS/2 data input
  output wire BTN_BOT, //output for the top,bottom,left,right,reset button
    output wire BTN_TOP,
    output wire BTN_LEFT,
    output wire BTN_RIGHT,
    output wire RST
  );

  //Signals for PS/2 keyborad interface
  wire ready, overflow;
  wire [7:0] raw_data;
  reg [7:0] last_raw, data;

  //Instantiate the PS/2 keyboard module
  ps2_keyboard ps2(clk, 1'b1, ps2_clk, ps2_data, 1'b0, raw_data, ready, overflow);

  always @(posedge clk) begin
    if (ready && raw_data != 8'he0) begin
      if (last_raw == 8'hf0) begin
        data <= 8'h00;
      end else if (raw_data != 8'hf0) begin
        data <= raw_data;
        //last_raw<=raw_data;
      end
      last_raw <= raw_data;
    end
  end

  //Register for storing button states
  reg up;
  reg down;
  reg left;
  reg right;
  reg rst;

  //Combinational logic block to determine button states based on data
  always @(*) begin
    case(data)
        8'h00: begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b0;
				    rst <= 1'b0;
        end
        8'h75: begin
            up <= 1'b1;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b0;
				    rst <= 1'b0;
        end
        8'h72: begin
            up <= 1'b0;
            down <= 1'b1;
            left <= 1'b0;
            right <= 1'b0;
				    rst <= 1'b0;
        end
        8'h6b: begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b1;
            right <= 1'b0;
				    rst <= 1'b0;
        end
        8'h74: begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b1;
				    rst <= 1'b0;
        end
        8'h2d:begin
            up<=1'b0;
            down<=1'b0;
            left<=1'b0;
            right<=1'b0;
            rst<=1'b1;
        end
        default: begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b0;
				    rst <= 1'b0;
        end
    endcase
  end

    // Assign button states to the corresponding output ports
    assign BTN_RIGHT=right;
    assign BTN_LEFT=left;
    assign BTN_TOP=up;
    assign BTN_BOT=down;
    assign RST=rst;

endmodule
