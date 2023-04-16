--Regiamorph Dipterror
function c26044003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26044003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(0)
	e1:SetCondition(c26044003.qcon)
	e1:SetTarget(c26044003.sptg)
	e1:SetOperation(c26044003.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetDescription(aux.Stringid(26044004,1))
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1a:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1a:SetCode(EVENT_FREE_CHAIN)
	e1a:SetLabel(1)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetRange(LOCATION_GRAVE)
	e1b:SetLabel(2)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetDescription(aux.Stringid(26044004,1))
	e1c:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1c:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1c:SetCode(EVENT_FREE_CHAIN)
	e1c:SetRange(LOCATION_GRAVE)
	e1c:SetLabel(3)
	e1c:SetCondition(c26044003.qcon)
	c:RegisterEffect(e1c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26044003.spcon)
	e2:SetTarget(c26044003.splimit)
	c:RegisterEffect(e2)
	--field play
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetDescription(aux.Stringid(26044003,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c26044003.ftg)
	e3:SetOperation(c26044003.fop)
	--c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	--c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e3b)
end
function c26044003.qcon(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabel()
	local opt1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil,tp)
	local opt2=Duel.IsPlayerAffectedByEffect(tp,26044012)
	return
	(lab==0 and not opt1) or
	(lab==1 and opt1) or
	(lab==2 and opt2 and not opt1) or
	(lab==3 and opt1 and opt2)
end
function c26044003.levelc(c,tc)
	return c:GetLevel()==tc:GetLevel()
end
function c26044003.spcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c26044003.splimit(e,c)
	return not c:HasLevel()
end
function c26044003.tgfilter(c,tp)
	return c:IsFaceup() and (c:IsLevelAbove(1) or c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT))
end
function c26044003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26044003.tgfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26044003.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and not c:IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044003,1))
	Duel.SelectTarget(tp,c26044003.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26044003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	local ct1=tc:IsLevelAbove(2) and not tc:IsImmuneToEffect(e) 
	local ct2=tc:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT)
	if not (ct1 or ct2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044003,2))
	local opt=Duel.SelectEffect(tp,
		{ct1,aux.Stringid(26044003,3)},
		{ct2,aux.Stringid(26044003,4)})
	if opt==1 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-1)
		tc:RegisterEffect(e1)
	elseif opt==2 then
		tc:RemoveCounter(tp,0x1045,1,REASON_EFFECT)
	end
	if opt~=0 then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c26044003.ffilter(c,tp)
	return c:IsCode(26044009) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26044003.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26044003.ffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
end
function c26044003.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26044003.ffilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end