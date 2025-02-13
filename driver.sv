class driver;
  transaction tr;
  mailbox #(transaction) mbx; //mailbox to receive data from the generator
  virtual dff_if vif; // virtual interface for DUT
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx; // mailbox for receiving data
  endfunction
  
  task reset();
    vif.rst <= 1'b1; 
    repeat(5) @(posedge vif.clk); 
    vif.rst <= 1'b0; 
    @(posedge vif.clk);
    $display("[DRV] : RESET DONE"); 
  endtask
  
  task run();
    forever begin
      mbx.get(tr); // get transaction from the generator
      vif.din <= tr.din; // Set DUT input from the transaction
      @(posedge vif.clk);
      tr.display("DRV"); 
      vif.din <= 1'b0; // Set DUT input to 0
      @(posedge vif.clk); 
    end
  endtask
  
endclass
