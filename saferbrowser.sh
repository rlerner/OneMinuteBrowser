VM="SaferBrowser$(date +%Y%m%d)"
isoLocation="/path/to/iso/xubuntu-17.10-desktop-amd64.iso"
netAdapter="wlp3s0"

# If the VM exists already, delete it w/o output
VBoxManage unregistervm $VM --delete > /dev/null 2>&1

# Create Virtual Machine
VBoxManage createvm --name $VM --ostype "Ubuntu_64" --register

# Install IDE controller on VM for boot image (ISO)
VBoxManage storagectl $VM --name "IDE Controller" --add ide

# Insert ISO disk into IDE DVD Drive
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $isoLocation

# Configure VM as follows:
# - Use UTC Timezone for RTC (Real Time Clock)
# - Enable audio output from VM to host
# - Set BIOS Logo Display Time to 0 ms (hide it)
# - Set VM Description
# - Enable I/O Advanced Programmable Interrupt Controllers (required for multiple VCPUs and x64 OS's)
# - Configure Boot Order (Net/PXE, disk) (todo: make boot 1 net for PXE and get rid of DVD/ISO)
# - Set RAM to 1GB, Video RAM to 128 MB
# - Bridge host's NIC to the adapter specified with "netAdpater" above
VBoxManage modifyvm $VM \
--rtcuseutc on \
--audioout on \
--bioslogodisplaytime 0 \
--description "Automatic Safer Browser" \
--ioapic on \
--boot1 dvd \
--memory 1024 --vram 128 \
--nic1 bridged --bridgeadapter1 "$netAdapter"
