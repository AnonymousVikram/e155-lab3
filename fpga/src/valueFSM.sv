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

  typedef enum logic [1:0] {
    WAIT,
    INPUT,
    HOLD,
    DEBOUNCE
  } fsmstates_t;

  fsmstates_t curState, nextState;

  always_comb begin : colOutput
    case (columnCounter)
      'b00: cols = 4'b1110;
      'b01: cols = 4'b1101;
      'b10: cols = 4'b1011;
      'b11: cols = 4'b0111;
      default: cols = 4'b1111;
    endcase
  end

  always_ff @(posedge clk) begin : stateController
    if (~nreset) begin
      curState <= WAIT;
    end else begin
      curState <= nextState;
    end
  end

  always_comb begin : nextStateLogic
    case (curState)
      WAIT: nextState = rows == 4'b1111 ? INPUT : WAIT;
      INPUT: nextState = rows == 4'b1111 ? WAIT : HOLD;
      HOLD: nextState = rows == 4'b1111 ? DEBOUNCE : HOLD;
      DEBOUNCE: nextState = rows == 4'b1111 || keyInput != curVal ? WAIT : HOLD;
      default: nextState = WAIT;
    endcase
  end

  always_ff @(posedge clk) begin : counterLogic
    if (~nreset) begin
      columnCounter <= 2'b00;
    end else if (curState == WAIT) begin
      columnCounter <= columnCounter == 2'b11 ? 2'b00 : columnCounter + 1;
    end
  end

  logic validKeyCombo;
  assign keyInputValid = curState == INPUT && validKeyCombo;

  always_comb begin : keyInputLogic
    case ({
      rows, cols
    })
      8'b1110_1110: begin
        keyInput = 4'h1;
        validKeyCombo = 1;
      end
      8'b1110_1101: begin
        keyInput = 4'h2;
        validKeyCombo = 1;
      end
      8'b1110_1011: begin
        keyInput = 4'h3;
        validKeyCombo = 1;
      end
      8'b1110_0111: begin
        keyInput = 4'hA;
        validKeyCombo = 1;
      end
      8'b1101_1110: begin
        keyInput = 4'h4;
        validKeyCombo = 1;
      end
      8'b1101_1101: begin
        keyInput = 4'h5;
        validKeyCombo = 1;
      end
      8'b1101_1011: begin
        keyInput = 4'h6;
        validKeyCombo = 1;
      end
      8'b1101_0111: begin
        keyInput = 4'hB;
        validKeyCombo = 1;
      end
      8'b1011_1110: begin
        keyInput = 4'h7;
        validKeyCombo = 1;
      end
      8'b1011_1101: begin
        keyInput = 4'h8;
        validKeyCombo = 1;
      end
      8'b1011_1011: begin
        keyInput = 4'h9;
        validKeyCombo = 1;
      end
      8'b1011_0111: begin
        keyInput = 4'hC;
        validKeyCombo = 1;
      end
      8'b0111_1110: begin
        keyInput = 4'hE;
        validKeyCombo = 1;
      end
      8'b0111_1101: begin
        keyInput = 4'h0;
        validKeyCombo = 1;
      end
      8'b0111_1011: begin
        keyInput = 4'hF;
        validKeyCombo = 1;
      end
      8'b0111_0111: begin
        keyInput = 4'hD;
        validKeyCombo = 1;
      end
      default: begin
        keyInput = 4'hx;
        validKeyCombo = 0;
      end
    endcase
  end

endmodule
