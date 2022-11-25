/*
		Ricochet用Bootloader リンカスクリプト
		2022.11.23 c0ntra1l
*/

/*
		メモリマップ(Bootloader実行時)
		0x000000 - 0x7FFFFF	Flash*
		0x100000 - 0x13FFFF	RAM(データ)
		0x200000 - 0x23FFFF	RAM(プログラム)

		メモリマップ(ユーザープログラム実行時)
		0x000000 - 0x13FFFF	RAM(プログラム)*
		0x100000 - 0x23FFFF	RAM(データ)

		*:実行するプログラム
*/

MEMORY {
	vec (r)		:	ORIGIN = 0x000000,	LENGTH = 0x400
	rom	(xr)	:	ORIGIN = 0x000400,	LENGTH = 512K - 0x400
	ram	(rw)	:	ORIGIN = 0x100000,	LENGTH = 256K
}

SECTIONS {
	/*ベクタ*/
	.isr_vector : {
		__rom_top = .;
		__rom_vec	= .;
	} > vec

	/*.textセクション*/
	.text : {
		__text_top = .;
		*(.text*)
		__text_bottom = .;
		*(.rodata*)
	} > rom

	/*.dataセクション*/
	.data :
	{
		__data_top = .;
		*(.data)
		__data_bottom = .;
	} > ram

	/*.bssセクション*/
	.bss :
	{
		__bss_top = .;
		*(.bss)
		*(COMMON)
		__bss_bottom = .;
		__stack_top = .;
	} > ram
}