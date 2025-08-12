--------------------------------------------
-- F-23A mod by ThunderStruck Simulations
--------------------------------------------

self_ID = "F-23A by ThunderStruck Simulations"

declare_plugin(self_ID, 
{
	image         = "FC3.bmp", 
	installed     = true, -- If false that will be place holder, or advertising.
	dirName       = current_mod_path, 
	developerName = _("ThunderStruck Simulations"), 
	fileMenuName  = _("F-23A Blk 20"), 
	displayName   = _("F-23A Blk 20"), 
	version       = _("Block 20"), 
	state         = "installed", 
	update_id     = "F-23A Blk 20", 
	info          = _("The F-23A is what would have been the US Air Force's next generation air superiority fighter if it had won the ATF program against the YF-22. It is powered by two Pratt & Whitney F119-PW-100 engines (is this correct?). The F-23A is a stealthy, air superiority fighter with advanced avionics and weapons systems."), -- GitHub copilot suggested this description, but it may not be accurate.
	creditsFile   = "credits.txt", 


	encyclopedia_path = current_mod_path .. "/Encyclopedia", 

	Skins = 
	{
		{
			name = _("F-23A"), 
			dir  = "Theme"
		}
	}, 

	Missions = 
	{
		{
			name = _("F-23A Blk 20"), 
			dir  = "Missions"
		}
	},

	LogBook = 
	{
		{
			name = _("F-23A Blk 20"),
			type = "F-23A"
		}
	}, 

	InputProfiles = {["F-23A"] = current_mod_path .. "/Input/F-23A"}
})



mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_model_path(current_mod_path .. "/Cockpit/Shape")

mount_vfs_liveries_path(current_mod_path .. "/Liveries")

mount_vfs_texture_path(current_mod_path .. "/Textures/Base")
mount_vfs_texture_path(current_mod_path .. "/Textures/Top")
mount_vfs_texture_path(current_mod_path .. "/Textures/Bottom")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_1")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_2")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_3")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_4")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_5")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_6")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_7")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_8")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_9")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_10")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-23A_Cockpit_11")



dofile(current_mod_path .. "/Weapons.lua")
dofile(current_mod_path .. "/Views.lua")
make_view_settings("F-23A", ViewSettings, SnapViews)


make_flyable("F-23A", current_mod_path .. "/Cockpit/Scripts/", {nil, old = 6}, current_mod_path .. "/Comm.lua")

dofile(current_mod_path .. "/F-23A.lua")



plugin_done()