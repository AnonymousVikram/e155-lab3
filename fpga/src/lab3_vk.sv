module lab3_vk (
    input logic [3:0] rows,
    input logic nreset,
    output logic lSegEn,
    rSegEn,
    output logic [3:0] cols,
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
  logic clkDiv240;  // 240Hz clock for seven segment display
  clockDivider #('d10000) clkDivMod240 (
      .clk(clk),
      .nreset(nreset),
      .clkDiv(clkDiv240)
  );

  logic clkDiv48;  // 48Hz clock for keypad
  clockDivider #('d400000) clkDivMod48 (
      .clk(clk),
      .nreset(nreset),
      .clkDiv(clkDiv48)
  );

  //* Setting up seven segment multiplexing using the divided clock signal
  assign lSegEn = clkDiv240;
  assign rSegEn = ~clkDiv240;

  //* Configuring the keypad decoder and FSM
  logic [3:0] keyInput, curVal, oldVal;
  logic keyInputValid;
  keypadDecoder keypadDecoderMod (
      .clk(clkDiv48),
      .nreset(nreset),
      .rows(rows),
      .cols(cols),
      .keyInput(keyInput),
      .keyInputValid(keyInputValid)
  );

  logic curValChanged;

  sevenSegController sevenSegControllerMod (
      .clk(clkDiv48),
      .nreset(nreset),
      .keyInputValid(keyInputValid),
      .keyInput(keyInput),
      .curVal(curVal),
      .curValChanged(curValChanged)
  );


  sevenSegOld sevenSegOldMod (
      .clk(clkDiv48),
      .nreset(nreset),
      .keyInputValid(curValChanged),
      .curVal(curVal),
      .oldVal(oldVal)
  );

  //* Instantiate seven segment decoder
  logic [3:0] segDecoderInput;

  assign segDecoderInput = clkDiv240 ? curVal : oldVal;

  sevenSegmentDecoder sevenSegmentDecoderMod (
      .inputHex(segDecoderInput),
      .segments(seg)
  );


endmodule
