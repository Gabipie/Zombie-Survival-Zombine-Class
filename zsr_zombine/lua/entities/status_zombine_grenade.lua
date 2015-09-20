--Zombie Survival Zombine Class by Mka0207 : http://steamcommunity.com/id/mka0207/
--Zombine Model from Half-Life 2 : Episode 1 by VALVE.

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"
ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.LifeTime = 4
ENT.NextTickSound = 0
ENT.GrenadeDamage = 45
ENT.GrenadeRadius = 256
ENT.Model = Model("models/weapons/w_grenade.mdl")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModel(self.Model)
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(false)

	self.DieTime = CurTime() + self.LifeTime
end

local matGlow = Material("sprites/glow04_noz")
function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local boneid = owner:LookupBone("ValveBiped.Bip01_L_Hand")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)
	
	local test = boneang:Up() * 3
	
	local test2 = boneang:Forward() * 5
	
	local test3 = boneang:Right() * 3
	
	local test4 = boneang:Up() * 2.5
	
	local test5 = boneang:Forward() * 6
	
	local test6 = boneang:Right() * -4

	self:SetPos( bonepos + test + test2 + test3 )
	boneang:RotateAroundAxis(boneang:Right(), 240)
	boneang:RotateAroundAxis(boneang:Forward(), -80)
	self:SetAngles(boneang)
	
	self:DrawModel()
	
	if CLIENT then

		render.SetMaterial(matGlow)
		render.DrawSprite(bonepos + test4 + test5 + test6, 16, 16, COLOR_RED)

		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.Pos = bonepos + test + test2 + test3
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.Brightness = 0.75
			dlight.Size = 64
			dlight.Decay = 256
			dlight.DieTime = CurTime() + 0.1
		end
	
	end

end

if SERVER then

function ENT:Think()
	if self.Exploded then
		self:Remove()
	elseif self.DieTime <= CurTime() then
		self:Explode()
		self.Owner:Kill()
	elseif not self.Owner:Alive() or not self.Owner:IsValid() then 
		self:Remove()
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_UNDEAD then
		local pos = self:GetPos()

		--util.PoisonBlastDamage(self, owner, pos, self.GrenadeRadius, self.GrenadeDamage, true)
		util.BlastDamage( self, owner, pos, self.GrenadeRadius, self.GrenadeDamage )
		
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata)
	end
end

end

if not CLIENT then return end

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime
end

function ENT:Think()
	
	local curtime = CurTime()

	if curtime >= self.NextTickSound then
		local delta = self.DieTime - curtime

		self.NextTickSound = curtime + math.max(0.2, delta * 0.25)
		self:EmitSound("weapons/grenade/tick1.wav", 75, math.Clamp((1 - delta / self.LifeTime) * 160, 100, 160))
	end
	

end