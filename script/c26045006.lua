--Planetheon Gravity
function c26045006.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26045006,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26045006.target)
	e1:SetOperation(c26045006.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26045006.target2)
	e2:SetOperation(c26045006.operation2)
	c:RegisterEffect(e2)
end
function c26045006.mtfilter(c,e)
	return not c:IsType(TYPE_TOKEN) and not c:IsImmuneToEffect(e) and c:GetSequence()<5
end
function c26045006.filter(c,e,tp,mg)
	local rk=c:GetRank()
	return c:IsSetCard(0x645)
	and #mg>=rk
	and Duel.GetLocationCountFromEx(tp,rp,nil,c,0x60)>0
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end
function c26045006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_SZONE,0,e:GetHandler(),e)
	local mg2=Duel.GetMatchingGroup(c26045006.mtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	mg:Merge(mg2)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045006.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26045006.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_SZONE,0,e:GetHandler(),e)
	local mg2=Duel.GetMatchingGroup(c26045006.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,nil,e)
	mg:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045006.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
	local rk=tc:GetRank()
	if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP,0x60)~=0 then
		local mg=mg:Select(tp,rk,rk,sc)
		Duel.Overlay(tc,mg)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterFlagEffect(26045006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26045006,2))
		tc:RegisterEffect(e1)
		--oath effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		--Duel.RegisterEffect(e1,tp)
		aux.RegisterClientHint(c,nil,tp,1,0,aux.Stringid(26045006,4),nil)
	end
end
function c26045006.filter2(c,e,tp,rp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x645) and Duel.GetLocationCount(tp,LOCATION_MZONE,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c26045006.ovfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c26045006.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26045006.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c26045006.ovfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c26045006.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,#g1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c26045006.ovfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c26045006.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:Filter(c26045006.filter2,nil,e,tp):GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE)
		and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local oc=tg:Filter(c26045006.mtfilter,tc,e,tp):GetFirst()
		if oc and oc:IsControler(1-tp) and oc:IsRelateToEffect(e) and not oc:IsImmuneToEffect(e) then
			oc:CancelToGrave()
			Duel.Overlay(tc,oc,true)
			Duel.Overlay(tc,e:GetHandler(),true)
		end
	end
end