
	.namespace prodos

filename	= $01
fileType	= $10
keyPtr		= fileType + 1
blockSize	= keyPtr + 2
EOF		= blockSize + 2
auxType		= $1F

	.end namespace
