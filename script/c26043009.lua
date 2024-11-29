--Hetredo Fusion
function c26043009.initial_effect(c)
	--Defusion
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043009,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26043009,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26043009.target)
	e1:SetOperation(c26043009.activate)
	c:RegisterEffect(e1)
	--fusion
	local params = {aux.FilterBoolFunction(Card.IsSetCard,0x643),nil,c26043009.fextra}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26043009,EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e2:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	e1:SetLabelObject(e2)
	c:RegisterEffect(e2)
	--polymerization
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)
	e0:SetValue(CARD_POLYMERIZATION)
	c:RegisterEffect(e0)
end
c26043009.listed_series={0x643}
c26043009.listed_names={CARD_POLYMERIZATION }
function c26043009.txfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function c26043009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26043009.txfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26043009.txfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26043009.mgfilter(c,e,tp,tc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and tc:ListsCodeAsMaterial(c:GetCode())
end
function c26043009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26043009.txfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,nil)
	if #g<1 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26043009.mgfilter),tp,LOCATION_GRAVE,0,nil,e,tp,tc)
	if tc and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>1 and #mg>1 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.SelectYesNo(tp,aux.Stringid(26043009,2)) then
			Duel.BreakEffect()
			local sg=aux.SelectUnselectGroup(mg,e,tp,2,ft,aux.dncheck,1,tp,HINTMSG_SELECT,nil,nil,true)
			local tc=sg:GetFirst()
			for tc in aux.Next(sg) do
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetValue(LOCATION_REMOVED)
					e3:SetReset(RESET_EVENT|RESETS_REDIRECT)
					tc:RegisterEffect(e3)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
	local eff2=e:GetLabelObject()
	local tg2=eff2:GetTarget()
	local op2=eff2:GetOperation()
	if tg2(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(26043009,3)) then
		op2(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c26043009.fcfilter(c,tc)
	return tc:ListsCodeAsMaterial(c:GetCode())
end
function c26043009.fcheck(tp,sg,fc)
	return sg:FilterCount(c26043009.fcfilter,nil,fc)==#sg
end
function c26043009.fextra(e,tp,mg)
	return nil,c26043009.fcheck
end