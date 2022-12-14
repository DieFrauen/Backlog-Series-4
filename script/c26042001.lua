--Quake Primeggidon - Behemoth
function c26042001.initial_effect(c)
	c:EnableReviveLimit()
	if not c26042001.global_check then
		c26042001.global_check=true
		c26042001[0]=false
		c26042001[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c26042001.check1)
		ge1:SetOperation(c26042001.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_GRAVE)
		ge2:SetCondition(c26042001.check2)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetCondition(c26042001.check3)
		Duel.RegisterEffect(ge3,0)
	end
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c26042001.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c26042001.discost)
	e4:SetOperation(c26042001.disop)
	c:RegisterEffect(e4)
end
function c26042001.checkg1(c)
	return c:GetPreviousLocation()==LOCATION_DECK and not c:IsReason(REASON_DRAW)
end
function c26042001.checkg2(c)
	return c:GetPreviousLocation()==LOCATION_DECK 
end
function c26042001.check1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042001.checkg1,nil)
	return g>0 and c26042001[rp]==false
end
function c26042001.check2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042001.checkg2,nil)
	return re and re:GetCategory()&CATEGORY_DECKDES ==0 and g>0 and c26042001[rp]==false
end
function c26042001.check3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042001.checkg2,nil)
	return g>0 and c26042001[rp]==false
end
function c26042001.checkop(e,tp,eg,ep,ev,re,r,rp)
	c26042001[rp]=true
	--Duel.Hint(HINT_CARD,1-rp,26042001)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0)
	e1:SetTarget(c26042001.bantg)
	e1:SetLabel(rp)
	Duel.RegisterEffect(e1,rp)
end
function c26042001.bantg(e,c)
	return c26042001[e:GetLabel()]==true and c:IsOriginalCodeRule(26042001)
end
function c26042001.filter(c)
	return c:GetPreviousLocation()==LOCATION_DECK and not c:IsReason(REASON_DRAW)
end
function c26042001.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26042001.filter,1,nil) and not eg:IsContains(e:GetHandler())  and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c26042001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c26042001.filter,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c26042001.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c26042001.filter,nil,e)
	if #g>0 then
		Duel.Hint(HINT_CARD,1-tp,26042001)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c26042001.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c26042001.disop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c26042001.operation)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_HAND)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SSET)
	Duel.RegisterEffect(e3,tp)
end
