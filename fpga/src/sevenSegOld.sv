/*
* File Author: Vikram Krishna (vkrishna@hmc.edu)
* File Created: September 15, 2024
* Summary: Store an old input internally and apply it when it differs from curVal
*/

module sevenSegOld (
    input logic clk,
    nreset,
    keyInputValid,
    input logic [3:0] curVal,
    output logic [3:0] oldVal
);
  // Implement a shift register to store the old value
  logic [3:0] curValBuffer, oldValBuffer;

  always_ff @(posedge clk) begin : shiftRegister
    if (~nreset) begin
      curValBuffer <= 4'h8;
      oldValBuffer <= 4'h8;
    end else begin
      curValBuffer <= keyInputValid ? curVal : curValBuffer;
      oldValBuffer <= curValBuffer == curVal ? oldValBuffer : curValBuffer;
    end
  end

  assign oldVal = oldValBuffer;
endmodule
