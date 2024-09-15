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
    output logic curValChanged
);

  logic [3:0] valBuffer;
  typedef enum logic [1:0] {
    WAITING,
    INPUT,
    HOLD
  } fsmstates_t;

  fsmstates_t curState, nextState;

  logic [3:0] valueBuffer;

  always_ff @(posedge clk) begin : stateController
    if (~nreset) begin
      curState  <= WAITING;
      nextState <= WAITING;
      curVal    <= 4'h8;
    end else begin
      case (curState)
        WAITING: nextState <= keyInputValid ? INPUT : WAITING;
        INPUT:   nextState <= keyInputValid ? HOLD : WAITING;
        HOLD:    nextState <= keyInputValid ? HOLD : WAITING;
      endcase
      curState <= nextState;
      curVal <= keyInputValid ? keyInput : curVal;
      curValChanged <= nextState == INPUT;
    end
  end


endmodule
