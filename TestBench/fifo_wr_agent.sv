class fifo_wr_agent extends uvm_agent;
  
  `uvm_component_utils(fifo_wr_agent)
  
  fifo_wr_sequencer wr_seqr;
  fifo_wr_driver wr_drv;
  fifo_wr_monitor wr_mon;
  
  function new(string name = "fifo_wr_agent",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
    wr_seqr = fifo_wr_sequencer::type_id::create("seqr",this);
    wr_drv = fifo_wr_driver::type_id::create("srv",this);
    end
    wr_mon = fifo_wr_monitor::type_id::create("mon",this);
  endfunction 
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      wr_drv.seq_item_port.connect(wr_seqr.seq_item_export);
    end
  endfunction
endclass
