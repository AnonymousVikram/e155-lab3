/*
* File Author: Vikram Krishna (vkrishna@hmc.edu)
* File Created: September 14, 2024
* Summary: SystemVerilog to decode a 16 input keypad
*/

module valueFSM (
    input logic clk,
    nreset,
    input logic [3:0] rows,
    input logic [3:0] curVal,
    output logic [3:0] cols,
    output logic [3:0] keyInput,
    output logic keyInputValid
);

  logic [1:0] columnCounter;
  logic validKeyCombo;

  keypadLUT keyLUT (
      .clk(clk),
      .nreset(nreset),
      .rows(rows),
      .cols(cols),
      .validKeyCombo(validKeyCombo),
      .keyInput(keyInput)
  );


  typedef enum logic [1:0] {
    WAIT,
    INPUT,
    HOLD,
    DEBOUNCE
  } fsmstates_t;

  fsmstates_t curState, nextState;

  always_comb begin : colOutput
    if (curState == WAIT) begin
      unique case (columnCounter)
        'b00: cols = 4'b1110;
        'b01: cols = 4'b1101;
        'b10: cols = 4'b1011;
        'b11: cols = 4'b0111;
      endcase
    end else cols = 4'b0000;
  end

  always_ff @(posedge clk) begin : stateController
    if (~nreset) begin
      curState <= WAIT;
    end else begin
      curState <= nextState;
    end
  end

  assign keyInputValid = curState == INPUT && validKeyCombo;
  always_comb begin : nextStateLogic
    case (curState)
      WAIT: nextState = rows === 4'b1111 ? WAIT : INPUT;
      INPUT: nextState = rows === 4'b1111 ? DEBOUNCE : HOLD;
      HOLD: nextState = rows === 4'b1111 ? DEBOUNCE : HOLD;
      DEBOUNCE: nextState = rows === 4'b1111 ? WAIT : HOLD;
      default: nextState = WAIT;
    endcase
  end


  always_ff @(posedge clk) begin : counterLogic
    if (~nreset) begin
      columnCounter <= 2'b00;
    end else if (nextState == WAIT) begin
      columnCounter <= columnCounter == 2'b11 ? 2'b00 : columnCounter + 1;
    end
  end

endmodule
