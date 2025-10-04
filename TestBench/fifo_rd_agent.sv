class fifo_rd_agent extends uvm_agent;
  
  `uvm_component_utils(fifo_rd_agent)
  
  fifo_rd_sequencer rd_seqr;
  fifo_rd_driver rd_drv;
  fifo_rd_monitor rd_mon;
  
  function new(string name = "fifo_rd_agent",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      rd_seqr = fifo_rd_sequencer::type_id::create("rd_seqr",this);
      rd_drv = fifo_rd_driver::type_id::create("rd_drv",this);
    end
    rd_mon = fifo_rd_monitor::type_id::create("mon",this);
  endfunction 
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
  endfunction
endclass
