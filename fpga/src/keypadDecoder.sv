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
        COL1: cols = 'b0001;
        COL2: cols = 'b0010;
        COL3: cols = 'b0100;
        COL4: cols = 'b1000;
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
        8'b0001_0001: begin
          keyInput = 'h1;
          keyInputValid = 'b1;
        end
        8'b0001_0010: begin
          keyInput = 'h2;
          keyInputValid = 'b1;
        end
        8'b0001_0100: begin
          keyInput = 'h3;
          keyInputValid = 'b1;
        end
        8'b0001_1000: begin
          keyInput = 'hA;
          keyInputValid = 'b1;
        end
        8'b0010_0001: begin
          keyInput = 'h4;
          keyInputValid = 'b1;
        end
        8'b0010_0010: begin
          keyInput = 'h5;
          keyInputValid = 'b1;
        end
        8'b0010_0100: begin
          keyInput = 'h6;
          keyInputValid = 'b1;
        end
        8'b0010_1000: begin
          keyInput = 'hB;
          keyInputValid = 'b1;
        end
        8'b0100_0001: begin
          keyInput = 'h7;
          keyInputValid = 'b1;
        end
        8'b0100_0010: begin
          keyInput = 'h8;
          keyInputValid = 'b1;
        end
        8'b0100_0100: begin
          keyInput = 'h9;
          keyInputValid = 'b1;
        end
        8'b0100_1000: begin
          keyInput = 'hC;
          keyInputValid = 'b1;
        end
        8'b1000_0001: begin
          keyInput = 'hE;
          keyInputValid = 'b1;
        end
        8'b1000_0010: begin
          keyInput = 'h0;
          keyInputValid = 'b1;
        end
        8'b1000_0100: begin
          keyInput = 'hF;
          keyInputValid = 'b1;
        end
        8'b1000_1000: begin
          keyInput = 'hD;
          keyInputValid = 'b1;
        end
        default: begin
          keyInput = 4'b0;
          keyInputValid = 0;
        end
      endcase
    end
  end


endmodule
