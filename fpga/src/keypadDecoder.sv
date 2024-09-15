/*
* File Author: Vikram Krishna (vkrishna@hmc.edu)
* File Created: September 14, 2024
* Summary: SystemVerilog to decode a 16 input keypad
*/

module keypadDecoder (
    input logic clk,
    nreset,
    input logic [3:0] rows,
    output logic [3:0] cols,
    keyInput,
    output logic keyInputValid
);
  typedef enum logic [1:0] {
    COL1,
    COL2,
    COL3,
    COL4
  } colscanstates_t;

  colscanstates_t state, nextState;

  // next state logic
  always_ff @(posedge clk) begin : register
    if (~nreset) begin
      state <= COL1;
      nextState <= COL1;
    end else begin
      state <= nextState;
      case (state)
        COL1: nextState <= COL2;
        COL2: nextState <= COL3;
        COL3: nextState <= COL4;
        COL4: nextState <= COL1;
        default: nextState <= COL1;
      endcase
    end
  end

  // Output logic for cols
  always_comb begin : colOutputLogic
    if (~nreset) cols = 'b1111;
    else
      case (state)
        COL1: cols = 'b1110;
        COL2: cols = 'b1101;
        COL3: cols = 'b1011;
        COL4: cols = 'b0111;
        default: cols = 'bz;
      endcase
  end

  // Output logic for keyInput

  always_comb begin : keyInputLogic
    if (~nreset) begin
      keyInput = 'b0000;
      keyInputValid = 'b0;
    end else begin
      case ({
        rows, cols
      })
        'b1110_1110: begin
          keyInputValid = 1;
          keyInput = 4'h1;
        end
        'b1101_1110: begin
          keyInputValid = 1;
          keyInput = 4'h2;
        end
        'b1011_1110: begin
          keyInputValid = 1;
          keyInput = 4'h3;
        end
        'b0111_1110: begin
          keyInputValid = 1;
          keyInput = 4'hA;
        end
        'b1110_1101: begin
          keyInputValid = 1;
          keyInput = 4'h4;
        end
        'b1101_1101: begin
          keyInputValid = 1;
          keyInput = 4'h5;
        end
        'b1011_1101: begin
          keyInputValid = 1;
          keyInput = 4'h6;
        end
        'b0111_1101: begin
          keyInputValid = 1;
          keyInput = 4'hB;
        end
        'b1110_1011: begin
          keyInputValid = 1;
          keyInput = 4'h7;
        end
        'b1101_1011: begin
          keyInputValid = 1;
          keyInput = 4'h8;
        end
        'b1011_1011: begin
          keyInputValid = 1;
          keyInput = 4'h9;
        end
        'b0111_1011: begin
          keyInputValid = 1;
          keyInput = 4'hC;
        end
        'b1110_0111: begin
          keyInputValid = 1;
          keyInput = 4'hE;
        end
        'b1101_0111: begin
          keyInputValid = 1;
          keyInput = 4'h0;
        end
        'b1011_0111: begin
          keyInputValid = 1;
          keyInput = 4'hF;
        end
        'b0111_0111: begin
          keyInputValid = 1;
          keyInput = 4'hD;
        end
        default: begin
          keyInput = 4'bzzzz;
          keyInputValid = 0;
        end
      endcase
    end
  end


endmodule
