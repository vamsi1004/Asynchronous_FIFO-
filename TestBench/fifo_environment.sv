class fifo_environment extends uvm_env;
  
  `uvm_component_utils(fifo_environment)
  
  fifo_rd_agent rd_agt;
  fifo_wr_agent wr_agt;
  fifo_scoreboard scb;
  fifo_subscriber cov;
  
  virtual_sequencer v_seqr;
  
  function new(string name = "fifo_environmet",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_agt = fifo_rd_agent::type_id::create("rd_agt",this);
    wr_agt = fifo_wr_agent::type_id::create("wr_agt",this);
    scb    = fifo_scoreboard::type_id::create("scb",this);
    cov    = fifo_subscriber::type_id::create("cov",this);
    v_seqr = virtual_sequencer::type_id::create("v_seqr",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wr_agt.wr_mon.wr_mon_port.connect(scb.wr_scb_port.analysis_export);
    wr_agt.wr_mon.wr_mon_port.connect(cov.wr_cov_port.analysis_export);
    rd_agt.rd_mon.rd_mon_port.connect(scb.rd_scb_port.analysis_export);
    rd_agt.rd_mon.rd_mon_port.connect(cov.rd_cov_port.analysis_export);
    
    v_seqr.wr_seqr = wr_agt.wr_seqr;
    v_seqr.rd_seqr = rd_agt.rd_seqr;
  endfunction 
  
endclass
