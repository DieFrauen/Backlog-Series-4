--Regiamorph Colony
function c26044011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26044011,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c26044011.cost)
	e2:SetTarget(c26044011.ctg)
	e2:SetOperation(c26044011.ctop)
	c:RegisterEffect(e2)
	--quick field play
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26044011,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c26044011.cost)
	e3:SetTarget(c26044011.ftg)
	e3:SetOperation(c26044011.fop)
	c:RegisterEffect(e3)
	--send level 1 insects to GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26044011,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c26044011.cost)
	e4:SetCountLimit(1,26044011,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c26044011.tgtg)
	e4:SetOperation(c26044011.tgop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(26044011,ACTIVITY_SPSUMMON,c26044011.counterfilter)
	
end
function c26044011.counterfilter(c)
	return c:HasLevel()
end
function c26044011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(26044011,6))
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26044011.splimit)
	Duel.RegisterEffect(e1,tp)
	
end
function c26044011.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:HasLevel()
end
function c26044011.ffilter(c,tp)
	return c:IsCode(26044009) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26044011.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26044011.ffilter,tp,LOCATION_DECK,0,1,nil,tp) and not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26044009),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(26044011)==0 end
	c:RegisterFlagEffect(26044011,RESET_CHAIN,0,1)
end
function c26044011.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c26044011.ffilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end
function c26044011.tgfilter(c)
	return ((c:IsRace(RACE_INSECT) and c:GetLevel()==1) or c:IsSetCard(0x644)) and c:IsAbleToGrave()
end
function c26044011.rescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==1
end
function c26044011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26044011.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,nil)
	if chk==0 then return #g>1 and aux.SelectUnselectGroup(g,e,tp,2,2,c26044011.rescon,0) and c:GetFlagEffect(26044011)==0 end
	c:RegisterFlagEffect(26044011,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND|LOCATION_DECK)
end
function c26044011.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26044011.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,nil)
	if #g<2 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c26044011.rescon,1,tp,HINTMSG_TOGRAVE)
	if #sg==2 then Duel.SendtoGrave(sg,REASON_EFFECT) end
end

function c26044011.cfilter(c,tp,tc)
	local ct=c:GetCounter(0x1045)
	return c:IsFaceup() and
	((c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT) and tc:IsCanAddCounter(0x1045,1)) or
	(tc:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT) and c:IsCanAddCounter(0x1045,1)))
end
function c26044011.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c26044011.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26044011.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c) and c:GetFlagEffect(26044011)==0 end
	c:RegisterFlagEffect(26044011,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044011,3))
	Duel.SelectTarget(tp,c26044011.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,c)
end
function c26044011.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local ct1=c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT) 
	local ct2=tc:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT) and Duel.CheckLPCost(tp,100)
	if not (ct1 or ct2) then return end
	local opt=Duel.SelectEffect(tp,
		{ct1,aux.Stringid(26044011,4)},
		{ct2,aux.Stringid(26044011,5)})
	local sc1,sc2=c,tc
	if opt==2 then sc1,sc2=sc2,sc1 end
	local ctt={}
	local ct=sc1:GetCounter(0x1045)
	for i=ct,1,-1 do
		if Duel.CheckLPCost(tp,i*100) and sc1:IsCanRemoveCounter(tp,0x1045,i,REASON_EFFECT) then
			table.insert(ctt,i)
		end
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(ctt))
	Duel.PayLPCost(tp,ac*100)
	sc1:RemoveCounter(tp,0x1045,ac,REASON_EFFECT)
	sc2:AddCounter(0x1045,ac)
end