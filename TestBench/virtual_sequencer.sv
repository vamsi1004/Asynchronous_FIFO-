class virtual_sequencer extends uvm_sequencer;
  
  `uvm_component_utils(virtual_sequencer)
  
  fifo_wr_sequencer wr_seqr;
  fifo_rd_sequencer rd_seqr;
  
  function new(string name = "virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction 
  
endclass
