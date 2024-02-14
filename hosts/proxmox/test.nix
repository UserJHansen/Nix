config: {
  config.terraform.resource.proxmox_vm_qemu.test_server = {
    count = 1;
    name = "test-vm-\${count.index + 1}";
    target_node = (import ./hosts.nix).compute;

    clone = (import ./templates.nix).cloudinit;

    cores   = 2;
    sockets = 1;
    memory  = 2048;

    scsihw = "virtio-scsi-pci";
    bootdisk = "scsi0";

    # Disk settings
    disks = {
      scsi = {
        scsi0 = {
          disk = {
            size = 10;
            storage = "local-lvm";
          };
        };
      };
    };
    network = {
      model = "virtio";
      bridge = "vmbr0";
    };
    
    ipconfig0 = "ip=172.16.0.4\${count.index + 1}/24,gw=172.16.0.1";
    cloudinit_cdrom_storage = "local-lvm";
    
    # sshkeys set using variables. the variable contains the text of the key.
    sshkeys = (import ../../wellknown).sshPublic;
  };
}