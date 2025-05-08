`timescale 1ns / 1ps


module top (
    input  logic RST,
    input  logic CLKIN,
    output logic LED
);

  logic clk, tgl;
  clk_core i_clk_core (
      .clk_in1(CLKIN),
      .reset(RST),
      .clk_out1(clk)
  );

  gen_1hz i_gen_1hz (
      .clk(clk),
      .rst(RST),
      .en_1hz(tgl)
  );

  always @(posedge tgl or posedge RST) begin
    if (RST) begin
      LED <= 1'b0;
    end else begin
      LED <= ~LED;
    end
  end


endmodule
