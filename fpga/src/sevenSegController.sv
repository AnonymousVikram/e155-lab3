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

  logic [3:0] inputBuffer;

  typedef enum logic [2:0] {
    WAITING,
    INPUT,
    HOLDING
  } fsmStates_t;

  fsmStates_t curState, nextState;

  assign curVal = inputBuffer;

  always_ff @(posedge clk) begin : overallLogic
    if (~nreset) begin
      curState <= WAITING;
    end else begin
      curState <= nextState;
    end
  end

  always_comb begin : outputLogic
    if (~nreset) begin
      oldVal = 0;
      inputBuffer = 0;
    end else begin
      case (curState)
        WAITING: begin
          if (keyInputValid) begin
            oldVal = inputBuffer;
            inputBuffer = keyInput;
          end
        end
        default: inputBuffer = inputBuffer;
      endcase
    end
  end

  always_comb begin : nextStateLogic
    if (~nreset) begin
      nextState = WAITING;
    end else begin
      case (curState)
        WAITING: nextState = keyInputValid ? INPUT : WAITING;
        INPUT, HOLDING: nextState = (keyInputValid && keyInput == inputBuffer) ? HOLDING : WAITING;
        default: nextState = WAITING;
      endcase
    end
  end


endmodule
