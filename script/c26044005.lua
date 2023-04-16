--Regiamorph Vespair
function c26044005.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26044005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c26044005.sptg)
	e1:SetOperation(c26044005.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCondition(c26044005.qcon)
	c:RegisterEffect(e1a)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26044005.spcon)
	e2:SetTarget(c26044005.splimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	--e2:SetCost(c26044005.spcost)
	c:RegisterEffect(e3)
end
function c26044005.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26044012)
end
function c26044005.spcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end

function c26044005.splimit(e,c)
	return not c:HasLevel()
end
function c26044005.filter(c,tp,lab)
	return c:IsFaceup() and c:IsCanRemoveCounter(tp,0x1045,1,REASON_EFFECT)
end
function c26044005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26044005.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26044005.filter,tp,0,LOCATION_MZONE,1,nil,tp) and not c:IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044005,1))
	Duel.SelectTarget(tp,c26044005.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26044005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	if opt~=0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ct=tc:GetCounter(0x1045)
		local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSetCard,0x644),tp,LOCATION_ONFIELD,0,nil)
		if #g==0 then return end
		if #g>ct then g=g:Select(tp,ct,ct,nil) end
		tc:RemoveCounter(tp,0x1045,#g,REASON_EFFECT)
		local sg,dm=g:GetFirst(),0
		while sg do
			sg:AddCounter(0x1045,1)
			dm=dm+200
			sg=g:GetNext()
		end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		--e1:SetCondition(c26044001.lvcon)
		e1:SetValue(#g*-1)
		local dm=Duel.Damage(1-tp,dm,REASON_EFFECT)
		Duel.BreakEffect()
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(dm*-1)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetValue(dm*-1)
		tc:RegisterEffect(e3)
	end
end
