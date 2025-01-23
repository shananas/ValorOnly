function _OnInit()
GameVersion = 0
print('Form Only Luxord Fix')
end

function GetVersion() --Define anchor addresses
if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
	OnPC = false
	GameVersion = 1
	print('Form Only Luxord Fix')
	Now = 0x032BAE0 --Current Location
	Save = 0x032BB30 --Save File
	Slot1    = 0x1C6C750 --Unit Slot 1
elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	OnPC = true
	if ReadString(0x9A9330,4) == 'KH2J' then --EGS
		GameVersion = 2
		print('Form Only Luxord Fix')
		Now = 0x0716DF8
		Save = 0x09A9330
		Slot1    = 0x2A23018
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
		GameVersion = 3
		print('Form Only Luxord Fix')
		Now = 0x0717008
		Save = 0x09A98B0
		Slot1    = 0x2A23598
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
		GameVersion = 4
		print('Form Only Luxord Fix')
		Now = 0x0717008
		Save = 0x09A98B0
		Slot1    = 0x2A23598
	elseif ReadString(0x9A7070,4) == "KH2J" or ReadString(0x9A70B0,4) == "KH2J" or ReadString(0x9A92F0,4) == "KH2J" then
		GameVersion = -1
		print("Epic Version is outdated. Please update the game.")
	elseif ReadString(0x9A9830,4) == "KH2J" then
		GameVersion = -1
		print("Steam Global Version is outdated. Please update the game.")
	elseif ReadString(0x9A8830,4) == "KH2J" then
		GameVersion = -1
		print("Steam JP Version is outdated. Please update the game.")
	end
end
end

function _OnFrame()
if GameVersion == 0 then --Get anchor addresses
	GetVersion()
	return
elseif GameVersion < 0 then --Incompatible version
	return
end
if true then --Define current values for common addresses
	World  = ReadByte(Now+0x00)
	Room   = ReadByte(Now+0x01)
	Place  = ReadShort(Now+0x00)
	Door   = ReadShort(Now+0x02)
	Map    = ReadShort(Now+0x04)
	Btl    = ReadShort(Now+0x06)
	Evt    = ReadShort(Now+0x08)
	PrevPlace = ReadShort(Now+0x30)
end
if  World == 0x012 and Room == 0x0E then
	if ReadByte (Save + 0x3524) ~= 1 and ReadByte (Save + 0x352B) == 0x02 then
		WriteByte(Save + 0x3524,1)
	end
	if ReadByte (Save + 0x352B) > 0x02 then
		WriteArray(Slot1 + 0x1B4,{0xC4,0x75,0xBB,0x45})
	end
end
end