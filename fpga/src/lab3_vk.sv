module lab3_vk (
    input logic [3:0] rows,
    cols,
    input logic nreset,
    output logic lSegEn,
    rSegEn,
    output logic [6:0] seg
);

  //* Setting up HSOSC and clk
  logic clk;
  HSOSC #(
      .CLKHF_DIV(2'b00)
  )  // ensures 48MHz clock
      hf_osc (
      .CLKHFPU(1'b1),
      .CLKHFEN(1'b1),
      .CLKHF  (clk)
  );

  //* Slowing down the clk
  logic clkDiv;
  clockDivider clkDivMod (
      .clk(clk),
      .nreset(nreset),
      .clkDiv(clkDiv)
  );

  //* Setting up seven segment multiplexing using the divided clock signal
  assign lSegEn = clkDiv;
  assign rSegEn = ~clkDiv;

  //* Configuring the keypad decoder and FSM
  logic [3:0] keyInput, curVal, oldVal;
  logic keyInputValid;
  keypadDecoder keypadDecoderMod (
      .rows(rows),
      .cols(cols),
      .keyInput(keyInput),
      .keyInputValid(keyInputValid)
  );

  sevenSegController sevenSegControllerMod (
      .clk(clkDiv),
      .nreset(nreset),
      .keyInputValid(keyInputValid),
      .keyInput(keyInput),
      .curVal(curVal),
      .oldVal(oldVal)
  );

  //* Instantiate seven segment decoder
  logic [3:0] segDecoderInput;

  assign segDecoderInput = clkDiv ? oldVal : curVal;

  sevenSegmentDecoder sevenSegmentDecoderMod (
      .inputHex(segDecoderInput),
      .segments(seg)
  );


endmodule
