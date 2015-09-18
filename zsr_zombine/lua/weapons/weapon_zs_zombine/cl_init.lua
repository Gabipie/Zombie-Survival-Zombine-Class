--Zombine SWEP by Mka0207 : http://steamcommunity.com/id/mka0207/
-- Viewmodel for Zombine by LuaKnight (Cpt.Hazama).
--Based off the Zombie SWEP Base by JetBoom.

include("shared.lua")

SWEP.PrintName = "Claws"
SWEP.ViewModelFOV = 60
SWEP.DrawCrosshair = false

function SWEP:Reload()
end

function SWEP:DrawWorldModel()
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
