
		.namespace	prodos

; a directory block: its 2 links, then 13 entries of $27 bytes
		.struct	DirBlock
prevBlock	.dw
nextBlock	.dw
		.end

; a directory entry: a file's, or a header ($Ex subdirectory, $Fx volume)
		.struct	DirEntry
storageLen	.db				; high nibble: storage type, low nibble: name length
name		.res	15
fileType	.db
keyPtr		.dw				; a file's index block, a directory's key block
blocksUsed	.dw
eof		.res	3
created		.res	4
version		.db
minVersion	.db
access		.db
auxType		.dw				; for a BIN file: its load address
modified	.res	4
headerPtr	.dw
		.end

STORAGE_MASK	=	$F0
NAMELEN_MASK	=	$0F
ST_SUBDIR_HDR	=	$E0
ST_VOLUME_HDR	=	$F0

		.end	namespace
