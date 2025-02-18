qemu-system-x86_64 \
    -m 8G \
	-smp 4 \
	-kernel workdir/bcs/case_0/arch/x86/boot/bzImage \
	-append "console=ttyS0 root=/dev/sda rw earlyprintk=serial net.ifnames=0" \
	-drive file=../../../../../SyzDirect_image/image/bookworm.img,format=raw \
	-net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
	-net nic,model=e1000 \
	-enable-kvm \
	-nographic \
	-pidfile vm.pid \
	-cpu host,kvm=on,hv_relaxed,hv_spinlocks=0x1fff,hv_time,hv_vapic,hv_vendor_id=0xDEADBEEFFF \
	2>&1 | tee vm.log

	#-nographic \
	#-virtfs local,path=/path/to/shared_mount,mount_tag=host0,security_model=passthrough,id=host0 \