int 0x13 is the bios interrupt vector 0x13 which is the 20th interrupt

This interrupt gives sector based read and write services. 
This uses CHS addressing for drives up to 8GB (I dont need more than that)

LBA replaces CHS addressing for bigger drives.

What int 0x13 expects in registers:
* ah = 0x02 for read mode or 0x03 for write
* dl = drive number (handled by GDT for this, hard disk usually 0x80)
* al = number of sectors to read
* es:bx = memory buffer address
* cl = sector number and upper cylinder bits
* ch = lower cylinder bits
* dh = head number
* then int 0x13 can be called

The number for the drive number has bit 7 as 0 if floppy disk and 1 for fixed drives

The BIOS sees the interrupt and handles the i/o accordingly
Afterwards the carry flag is set to 0 for success and 1 for fail
On success, ah is typically 0 and on failure it is an error code
