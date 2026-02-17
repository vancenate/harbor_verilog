#!/bin/bash

# Reference solution for the rounding division task
# Creates solution_core.sv with correct implementation

cat > /workspace/solution_core.sv << 'EOF'
module solution_core #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);

    logic [OUT_WIDTH:0] temp;

    assign temp = din[IN_WIDTH-1:DIV_LOG2] + din[DIV_LOG2-1];
    assign dout = (temp[OUT_WIDTH] == 1 ? din[IN_WIDTH-1:DIV_LOG2] : temp[OUT_WIDTH-1:0]);

endmodule
EOF

echo "Created solution_core.sv in /workspace"
