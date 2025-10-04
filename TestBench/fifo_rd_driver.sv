class fifo_rd_driver extends uvm_driver #(rd_seq_item);
  
  virtual fifo_interface.rd_drv vif;
  `uvm_component_utils(fifo_rd_driver)
  
  function new(string name = "fifo_rd_driver",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_interface)::get(this,"","password",vif))
      `uvm_fatal("READ_DRIVER","!!!No virtual interface!!!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
  
  task drive();
    @(posedge vif.rd_drv_cb)
    //     while(vif.rd_drv_cb.rempty)
//           begin 
    //         @(posedge vif.rd_drv_cb);
//           end
    vif.rd_drv_cb.rinc <= req.rinc;
    `uvm_info("READ_DRIVER",$sformatf("Driving from read driver"),UVM_LOW);
    req.print();
  endtask
endclass
