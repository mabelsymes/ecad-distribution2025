module twotrafficlights(
      input  logic clk,
      input  logic rst,
      output logic [2:0] lightsA, 
      output logic [2:0] lightsB
    );
  logic [2:0] state;

  always_comb begin
    if (state[2]) begin
      lightsB = 3'b100;
      case (state[1:0])
        2'b00: lightsA = 3'b110;
        2'b01: lightsA = 3'b001;
        2'b10: lightsA = 3'b010;
        2'b11: lightsA = 3'b100;
      endcase
    end else begin
      lightsA = 3'b100;
      case (state[1:0])
        2'b00: lightsB = 3'b110;
        2'b01: lightsB = 3'b001;
        2'b10: lightsB = 3'b010;
        2'b11: lightsB = 3'b100;
      endcase
    end
  end

  always_ff @(posedge clk) begin
    if (rst)
      state <= 0;
    else
      state <= state + 1;
  end

endmodule
