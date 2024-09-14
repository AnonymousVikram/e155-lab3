/*
* File Author: Vikram Krishna (vkrishna@hmc.edu)
* File Created: September 13, 2024
* Summary: SystemVerilog to divide a clock
*/

module clockDivider #(
    parameter CLOCKWAIT = 'd100000
) (
    input  logic clk,
    input  logic nreset,
    output logic clkDiv
);
  logic [31:0] counter;

  always_ff @(posedge clk) begin
    if (!nreset) begin
      counter <= 0;
      clkDiv  <= 1;
    end else if (counter > CLOCKWAIT) begin
      clkDiv  <= ~clkDiv;
      counter <= 0;
    end else counter <= counter + 1;
  end
endmodule
