--Regiamorph Meganeuropa
function c26044008.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(26044001),1,1,nil,4,99)
	c:EnableReviveLimit()
	--attackup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c26044008.attackup)
	c:RegisterEffect(e1)
	--absorb Scale Counters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26044008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c26044008.cttg)
	e2:SetOperation(c26044008.ctop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c26044008.immval)
	c:RegisterEffect(e1)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26044008,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	--e4:SetCondition(c26044008.spcon)
	e4:SetTarget(c26044008.sptg)
	e4:SetOperation(c26044008.spop)
	c:RegisterEffect(e4)
	--burst counters
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c26044008.ctspop)
	c:RegisterEffect(e5)
	
end

c26044008.counter_place_list={0x1045}
function c26044008.attackup(e,c)
	return c:GetCounter(0x1045)*100
end

function c26044008.immval(e,te)
	local tc=te:GetOwner()
	return tc:GetCounter(0x1045)==0 and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c26044008.ctfilter(c,tp)
	return c:IsFaceup() and c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT)
end
function c26044008.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c26044008.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
end
function c26044008.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,c26044008.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
	if not tc then return end
	local ct=tc:GetCounter(0x1045)
	tc:RemoveCounter(tp,0x1045,ct,REASON_EFFECT)
	c:AddCounter(0x1045,ct)
	--Duel.Damage(1-tp,count*100,REASON_EFFECT)
end
function c26044008.ctspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1045)
	local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,c)
	if ct==0 or #tg==0 then return end
	local ctt=math.floor(ct/#tg)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		tc:AddCounter(0x1045,ctt)
	end
end

function c26044008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045,20,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26044008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045,20,REASON_EFFECT) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end