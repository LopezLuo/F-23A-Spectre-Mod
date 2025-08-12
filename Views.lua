--------------------------------------------
--F-23A mod by ThunderStruck Simulations
--------------------------------------------

ViewSettings = {
	Cockpit = {
		CockpitAnchorPoint = {6.1, 1.22, 0}, --{6.6, 1.22, 0}, --{0.0884, 0.23, 0}, 
		[1] = {
			CockpitLocalPoint = {6.3, 1.23, 0}, --{6.4, 1.22, 0} --Cockpit placement, Forward/back, Up/down, Left/right
			CameraViewAngleLimits = {20, 140}, 
			CameraAngleRestriction = {false, 90, 0.5}, 
			CameraAngleLimits      = {200, -80, 110}, --Head turn = left right, down, up
			EyePoint               = {0, 0, 0}, --Up/Down, ?, Left/Right
			limits_6DOF            = {x = {-0.05, 0.45}, y = {-0.3, 0.1}, z = {-0.22, 0.22}, roll = 90}, --Move = back forwards, up down, left right
			ShoulderSize           = 0.15, --Moves body when azimuth value is more than 90 degrees
			Allow360rotation       = false
		}
	}, --Cockpit
	Chase = {
		LocalPoint = {2.532, 1.8, 0}, 
		AnglesDefault = {0, 0}
	}, --Chase
	Arcade = {
		LocalPoint = {-13.79, 6.204, 0}, --TODO: adjust arcade position
		AnglesDefault = {0, -8}
	} --Arcade 
}

SnapViews = {
	[1] = { --Player slot 1
		[1] = { --LWin + Num0: Snap View 0
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[2] = { --LWin + Num1 : Snap View 1
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[3] = { --LWin + Num2 : Snap View 2
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[4] = { --LWin + Num3 : Snap View 3
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[5] = { --LWin + Num4 : Snap View 4
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[6] = { --LWin + Num5 : Snap View 5
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[7] = { --LWin + Num6 : Snap View 6
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[8] = { --LWin + Num7 : Snap View 7
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[9] = { --LWin + Num8 : Snap View 8
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[10] = { --LWin + Num9 : Snap View 9
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[11] = { --Look at left  mirror
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[12] = { --Look at right mirror
			viewAngle = 60, --FOV
			hAngle = 0, 
			vAngle = 0, 
			x_trans = 0, 
			y_trans = 0, 
			z_trans = 0, 
			rollAngle = 0
		},
		[13] = { --Default view TODO: Review these numbers
			viewAngle = 88.727844, --FOV
			hAngle = 0, 
			vAngle = -8.41485, 
			x_trans = 0.247411, 
			y_trans = -0.067882, 
			z_trans = 0, 
			rollAngle = 0
		}
	}
}