module gen_1hz (
    input  logic clk,
    input  logic rst,
    output logic en_1hz
);

  logic [26:0] cnt100M;

  parameter CNT100M_MAX = 27'd99_999_999;  // 100M clock

  always_ff @(posedge clk) begin
    if (rst) begin
      cnt100M <= 27'b0;
    end else begin
      if (cnt100M <= CNT100M_MAX) cnt100M <= cnt100M + 1;
      else begin
        cnt100M <= 27'b0;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      en_1hz <= 1'b0;
    end else begin
      if (cnt100M == CNT100M_MAX) begin
        en_1hz <= 1'b1;
      end else begin
        en_1hz <= 1'b0;
      end
    end
  end

endmodule
