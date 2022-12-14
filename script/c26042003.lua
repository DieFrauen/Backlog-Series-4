--Storm Primeggidon - Zuys
function c26042003.initial_effect(c)
	c:EnableReviveLimit()
	if not c26042003.global_check then
		c26042003.global_check=true
		c26042003[0]=false
		c26042003[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c26042003.check1)
		ge1:SetOperation(c26042003.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_GRAVE)
		ge2:SetCondition(c26042003.check2)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetCondition(c26042003.check3)
		Duel.RegisterEffect(ge3,0)
	end
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c26042003.discost)
	e1:SetOperation(c26042003.disop)
	c:RegisterEffect(e1)
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0x7d,0x7d)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetOperation(c26042003.disop2)
	--c:RegisterEffect(e4)
	--aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
function c26042003.checkg1(c)
	return c:GetPreviousLocation()==LOCATION_DECK and not c:IsReason(REASON_DRAW)
end
function c26042003.checkg2(c)
	return c:GetPreviousLocation()==LOCATION_DECK 
end
function c26042003.check1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042003.checkg1,nil)
	return g>0 and c26042003[rp]==false
end
function c26042003.check2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042003.checkg2,nil)
	return re and re:GetCategory()&CATEGORY_DECKDES ==0 and g>0 and c26042003[rp]==false
end
function c26042003.check3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042003.checkg2,nil)
	return g>0 and c26042003[rp]==false
end
function c26042003.checkop(e,tp,eg,ep,ev,re,r,rp)
	c26042003[rp]=true
	--Duel.Hint(HINT_CARD,1-rp,26042003)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0)
	e1:SetTarget(c26042003.bantg)
	e1:SetLabel(rp)
	Duel.RegisterEffect(e1,rp)
end
function c26042003.bantg(e,c)
	return c26042003[e:GetLabel()]==true and c:IsOriginalCodeRule(26042003)
end
function c26042003.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c26042003.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c26042003.disop2)
	--Duel.RegisterEffect(e1,tp)
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(0x7d,0x7d)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	Duel.RegisterEffect(e3,tp)
end
function c26042003.disop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetActivateLocation()==LOCATION_HAND and rc:IsType(TYPE_MONSTER) then
		if Duel.NegateEffect(ev) then
			Duel.Hint(HINT_CARD,1-tp,26042003)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,1)
			e1:SetLabel(ev)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c26042003.elimit(e,re,tp)
	return re==e:GetLabel()
end