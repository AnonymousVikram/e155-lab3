/*
* File Author: Vikram Krishna (vkrishna@hmc.edu)
* File Created: September 14, 2024
* Summary: SystemVerilog to decode a 16 input keypad
*/

module keypadDecoder (
    input logic [3:0] rows,
    cols,
    output logic [3:0] keyInput,
    output logic keyInputValid
);

  always_comb begin
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
        keyInput = 'bx;
        keyInputValid = 0;
      end
    endcase
  end
endmodule
