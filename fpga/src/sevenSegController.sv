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
  logic [3:0] nextCurVal, nextOldVal, curValBuffer;

  typedef enum logic [1:0] {
    WAITING,
    INPUT,
    HOLD
  } fsmstates_t;

  fsmstates_t curState, nextState;

  assign nextCurVal = keyInput;
  assign nextOldVal = curValBuffer;
  assign curVal = curValBuffer;

  always_ff @(posedge clk) begin : stateController
    if (~nreset) begin
      curState  <= WAITING;
      nextState <= WAITING;
    end else begin
      case (curState)
        WAITING: begin
          if (keyInputValid) begin
            nextState <= INPUT;
          end else nextState <= WAITING;
        end
        INPUT, HOLD: nextState <= (keyInputValid && keyInput == curVal) ? HOLD : WAITING;
        default: begin
          nextState <= WAITING;
        end
      endcase
    end
    curState <= nextState;
  end

  always_ff @(posedge clk) begin
    if (~nreset) begin
      curValBuffer <= 'bz;
      oldVal <= 'bz;
    end else if (nextState == INPUT) begin
      oldVal <= nextOldVal;
      curValBuffer <= nextCurVal;
    end
  end

endmodule
