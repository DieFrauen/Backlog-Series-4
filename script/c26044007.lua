--Regiamorph Lepideus
function c26044007.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(26044001),1,1,nil,1,99)
	c:EnableReviveLimit()
	--Add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c26044007.op)
	c:RegisterEffect(e1)
	--spread Scale Counters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26044007,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c26044007.cttg)
	e2:SetOperation(c26044007.ctop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26044007.discon)
	e3:SetOperation(c26044007.disop)
	c:RegisterEffect(e3)
end
function c26044007.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if ((re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)) or re:IsActiveType(TYPE_MONSTER)) then
		Duel.Hint(HINT_CARD,tp,26044007)
		c:AddCounter(0x1045,1)
		if rc~=c then rc:AddCounter(0x1045,1) end
	end
end
function c26044007.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,#g,0,0)
	local ct=e:GetHandler():GetCounter(0x1045)
	if #g<ct then ct=#g end
	if #g~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
	end
end
function c26044007.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local c=e:GetHandler()
	local ct,count=c:GetCounter(0x1045),0
	if #g>ct then g=g:Select(tp,ct,ct,nil) end
	for tc in aux.Next(g) do
		if not tc:IsImmuneToEffect(e) then
			tc:AddCounter(0x1045,1)
			count=count+1
		end
	end
	e:GetHandler():RemoveCounter(tp,0x1045,count,REASON_EFFECT)
	Duel.Damage(1-tp,count*100,REASON_EFFECT)
end
function c26044007.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ct=rc:GetCounter(0x1045)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp~=tp and ct>2 and rc:GetLevel()<ct
end
function c26044007.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
