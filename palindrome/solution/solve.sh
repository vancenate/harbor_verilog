#!/bin/bash

# Reference solution for the palindrome task
# Creates solution_core.sv with correct implementation

cat > /workspace/solution_core.sv << 'EOF'
module solution_core #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

    int i;
    logic is_palindrome;

    always @* begin
        is_palindrome = 1;
        for (i=0; i<DATA_WIDTH/2; i++) begin
            is_palindrome = (din[i] == din[DATA_WIDTH-1-i]) && is_palindrome;
        end
    end

    assign dout = is_palindrome;

endmodule
EOF

echo "Created solution_core.sv in /workspace"