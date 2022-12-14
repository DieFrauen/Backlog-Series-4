--Fathoms of Meggidon
function c26042011.initial_effect(c)
	c:EnableCounterPermit(0x25)
	c:SetCounterLimit(0x25,10)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_SPSUMMON)
	e1:SetCost(c26042011.cost)
	c:RegisterEffect(e1)
	--act from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c26042011.qpcond)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(7)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c26042011.condition)
	e3:SetTarget(c26042011.target)
	e3:SetOperation(c26042011.operation)
	c:RegisterEffect(e3)
end
function c26042011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26042011.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e2:SetDescription(aux.Stringid(26042011,0))
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function c26042011.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE)) and (sumtype&SUMMON_TYPE_RITUAL)~=SUMMON_TYPE_RITUAL 
end
function c26042011.qpcond(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain(true)
	local ce=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
	local ex,tg,ct,p,l=Duel.GetOperationInfo(ch,CATEGORY_SPECIAL_SUMMON)
	return ex and
	(((l&LOCATION_GRAVE)~=0 or (l&LOCATION_DECK)~=0) or (tg and tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))
end
function c26042011.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c26042011.filter(c)
	return c:IsReleasable()
	and c:GetSummonLocation()&LOCATION_DECK+LOCATION_GRAVE~=0
end
function c26042011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lev=eg:GetSum(Card.GetLevel)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local cond1=eg:IsExists(c26042011.filter,1,nil) and lev>0 and c:IsCanAddCounter(0x25,1,true)
	local cond2=(ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,26042000,0,TYPES_TOKEN,0,0,-2,RACE_SEASERPENT,ATTRIBUTE_WATER,POS_FACEUP) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) and c:GetCounter(0x25)>0)
	if chk==0 then return cond1 or cond2 end
	if cond1 then
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,eg,1,0,0) 
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x25)
	end
	if cond2 then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	end
end
function c26042011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c26042011.filter,nil)
	local lev=eg:GetSum(Card.GetLevel)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local s1=#g>0 and lev>0 and c:IsCanAddCounter(0x25,1,true)
	local s2=(ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,26042000,0,TYPES_TOKEN,0,0,-2,RACE_SEASERPENT,ATTRIBUTE_WATER,POS_FACEUP) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN))
	local s3=(s1 and s2)
	local ops,opval,off={},{},1
	if s1 then
		ops[off]=aux.Stringid(26042011,1)
		opval[off-1]=1
		off=off+1
	end
	if s2 and c:GetCounter(0x25)>0 then
		ops[off]=aux.Stringid(26042011,2)
		opval[off-1]=2
		off=off+1
	end
	if s3 then
		ops[off]=aux.Stringid(26042011,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]~=2 then
		local sg=g:Select(tp,1,1,nil):GetFirst()
		if sg then
			Duel.Release(sg,REASON_EFFECT)
			c:AddCounter(0x25,sg:GetLevel(),true)
		end
	end
	if opval[op]~=1 then
		Duel.BreakEffect()
		local ac=c:GetCounter(0x25)
		local token=Duel.CreateToken(tp,26042000)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(0+(ac*300))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(0+(ac*300))
			token:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			e3:SetValue(ac)
			token:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
		end
	end
end
