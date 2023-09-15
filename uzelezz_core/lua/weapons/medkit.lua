SWEP.Base = 'weapon_base'
AddCSLuaFile()

SWEP.PrintName = "Аптечка"
SWEP.Author = "First AID"
SWEP.Purpose = "Лечит и уберай кровоток"

SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.Spawnable = true

SWEP.ViewModel = "models/w_models/weapons/w_eq_medkit.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_eq_medkit.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false
local healsound = Sound("snd_jack_bandage.wav")
function SWEP:Initialize()
	self:SetHoldType( "slam" )
	if ( CLIENT ) then return end
end

if(CLIENT)then
	function SWEP:PreDrawViewModel(vm,wep,ply)
	end
	function SWEP:GetViewModelPosition(pos,ang)
		pos=pos-ang:Up()*10+ang:Forward()*30+ang:Right()*7
		ang:RotateAroundAxis(ang:Up(),90)
		ang:RotateAroundAxis(ang:Right(),-10)
		ang:RotateAroundAxis(ang:Forward(),-10)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		self:DrawModel()
		if (IsValid(self:GetOwner())) then 
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) 
			if((Pos)and(Ang))then
				self:SetRenderOrigin(Pos+Ang:Forward()*3.6+Ang:Right()*0.5)
				Ang:RotateAroundAxis(Ang:Up(),0)
				Ang:RotateAroundAxis(Ang:Right(),0)
				Ang:RotateAroundAxis(Ang:Forward(),90)
				self:SetModelScale(1)
				self:SetRenderAngles(Ang)
				self:DrawModel()
			end
		end
	end
end
function SWEP:PrimaryAttack()
self.Owner:SetAnimation(PLAYER_ATTACK1)
if(SERVER)then
if self.Owner:GetNWInt("Blood")<4400 then
self.Owner:SetNWInt("Blood",math.Clamp(self.Owner:GetNWInt("Blood")+150,0,5000))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
if self.Owner:GetNWInt("pain")>50 then
self.Owner:SetNWInt("painlosing",math.Clamp(self.Owner:GetNWInt("painlosing")+2.5,1,15))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
if self:GetOwner():GetNWInt("BloodLosing")>0 then
self:GetOwner():SetNWInt("BloodLosing",self.Owner:GetNWInt("BloodLosing") - 70)
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
if self.Owner:Health()<100 then
self:Remove()
self.Owner:SetHealth(math.Clamp(self.Owner:Health()+45,0,100))
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
end
end
function SWEP:SecondaryAttack()
self.Owner:SetAnimation(PLAYER_ATTACK1)
if(SERVER)then
local tr = util.TraceHull( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 48 ),
	filter = self.Owner,
	mins = Vector( -10, -10, -10 ),
	maxs = Vector( 10, 10, 10 ),
} )
WhomILookinAt=tr.Entity
if IsValid(WhomILookinAt) then
if WhomILookinAt:IsPlayer() then
if WhomILookinAt:GetNWInt("Blood")<4800 then
WhomILookinAt:SetNWInt("Blood",math.Clamp(WhomILookinAt:GetNWInt("Blood")+150,0,5000))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
if WhomILookinAt:GetNWInt("pain")>50 then
WhomILookinAt:SetNWInt("painlosing",math.Clamp(WhomILookinAt:GetNWInt("painlosing")+2.5,1,15))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end

if WhomILookinAt:GetNWInt("BloodLosing")>0 then
WhomILookinAt:SetNWInt("BloodLosing",WhomILookinAt:GetNWInt("BloodLosing") - 70)
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
if WhomILookinAt:Health()<100 then
self:Remove()
WhomILookinAt:SetHealth(math.Clamp(WhomILookinAt:Health()+45,0,100))
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
end
	end 
	if WhomILookinAt:IsRagdoll() then
		if !IsValid(RagdollOwner(WhomILookinAt)) then return nil end
		if RagdollOwner(WhomILookinAt):GetNWInt("Blood")<4800 then
		RagdollOwner(WhomILookinAt):SetNWInt("Blood",math.Clamp(RagdollOwner(WhomILookinAt):GetNWInt("Blood")+150,0,5000))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
if RagdollOwner(WhomILookinAt):GetNWInt("pain")>50 then
RagdollOwner(WhomILookinAt):SetNWInt("painlosing",math.Clamp(RagdollOwner(WhomILookinAt):GetNWInt("painlosing")+2.5,1,15))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end

if RagdollOwner(WhomILookinAt):GetNWInt("BloodLosing")>0 then
RagdollOwner(WhomILookinAt):SetNWInt("BloodLosing",RagdollOwner(WhomILookinAt):GetNWInt("BloodLosing") - 70)
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
if WhomILookinAt:Health()<100 then
self:Remove()
RagdollOwner(WhomILookinAt):SetHealth(math.Clamp(RagdollOwner(WhomILookinAt):Health()+45,0,100))
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
	end
end
end
