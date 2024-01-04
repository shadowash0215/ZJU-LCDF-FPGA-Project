module mykeyboard(
  input wire clk,
  input wire ps2_clk,
  input wire ps2_data,
  output wire BTN_BOT,
    output wire BTN_TOP,
    output wire BTN_LEFT,
    output wire BTN_RIGHT,
    output wire RST
);

//   localparam NoKey = 4'b0000;
//   localparam Up = 4'b0001;
//   localparam Down = 4'b0010;
//   localparam Left = 4'b0100;
//   localparam Right = 4'b1000;
//   localparam OtherKey = 4'b1111;

  wire ready, overflow;
  wire [7:0] raw_data;
  reg [7:0] last_raw, data;
  ps2_keyboard ps2(clk, 1'b1, ps2_clk, ps2_data, 1'b0, raw_data, ready, overflow);

  always @(posedge clk) begin
    if (ready && raw_data != 8'he0) begin
      if (last_raw == 8'hf0) begin
        data <= 8'h00;
      end else if (raw_data != 8'hf0) begin
        data <= raw_data;
        last_raw<=raw_data;
      end
    end
  end

  reg up;
  reg down;
  reg left;
  reg right;
  reg rst;

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

    assign BTN_RIGHT=right;
    assign BTN_LEFT=left;
    assign BTN_TOP=up;
    assign BTN_BOT=down;
    assign RST=rst;


//   assign key = (data==8'h00)?NoKey:
//                (data==8'h75)?Up:
//                (data==8'h72)?Down:
//                (data==8'h6b)?Left:
//                (data==8'h74)?Right:
//                OtherKey;
endmodule