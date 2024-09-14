/*
* File Author: Vikram Krishna (vkrishna@hmc.edu)
* File Created: September 14, 2024
* Summary: Manage and store keypad inputs
*/

module sevenSegController (
    input logic clk,
    nreset,
    keyInputValid,
    input logic [3:0] keyInput,
    output logic [3:0] curVal,
    oldVal
);

  logic [3:0] curValBuffer;

  typedef enum logic [2:0] {
    WAITING,
    INPUT,
    HOLDING
  } fsmStates_t;

  fsmStates_t curState, nextState;

  assign curVal = curValBuffer;

  always_ff @(posedge clk) begin
    if (~nreset) begin
      curValBuffer <= 0;
      oldVal <= 0;
      nextState <= WAITING;
    end else begin
      curState <= nextState;
      case (curState)
        WAITING: begin
          if (keyInputValid) begin
            oldVal <= curValBuffer;
            curValBuffer <= keyInput;

            nextState <= INPUT;
          end
        end
        INPUT, HOLDING:
        nextState <= (keyInputValid && keyInput == curValBuffer) ? HOLDING : WAITING;
        default: nextState <= WAITING;
      endcase
    end

  end


endmodule
