--Hetredox Warmonger
function c26043006.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,26043002,26043003)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043006,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c26043006.rmcost)
	e1:SetTarget(c26043006.rmtg)
	e1:SetOperation(c26043006.rmop)
	c:RegisterEffect(e1)
end
function c26043006.poly(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsDiscardable()
end
function c26043006.rmfilter(c,tp)
	return c:IsAbleToRemove() or
	c:IsCanBeFusionMaterial() or
	c:IsCanBeSynchroMaterial() or
	c:IsCanBeXyzMaterial() or
	c:IsCanBeLinkMaterial()
end
function c26043006.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c26043006.poly,tp,LOCATION_HAND,0,nil)local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)if chk==0 then return #g1>0 or #g2>1 end
	if #g2>1 then return end
	local sg=g1:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c26043006.rmfilter(c,tp)
	return c:IsFaceup() and
	(c:IsCanBeFusionMaterial() or
	c:IsCanBeSynchroMaterial() or
	c:IsCanBeXyzMaterial()  or
	c:IsCanBeLinkMaterial() or
	c:IsAbleToRemove(tp))
end
function c26043006.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c26043006.rmfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c26043006.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c26043006.exfilter(c,sfunc)
	return sfunc(c) 
end
function c26043006.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local op=1-tp
	if tc and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_MUST_BE_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetValue(REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK)
		e3:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e3)
		local sg=Duel.GetMatchingGroup(c26043006.exfilter,op,LOCATION_EXTRA,0,nil,Card.IsSynchroSummonable)
		local xg=Duel.GetMatchingGroup(c26043006.exfilter,op,LOCATION_EXTRA,0,nil,Card.IsXyzSummonable)
		local lg=Duel.GetMatchingGroup(c26043006.exfilter,op,LOCATION_EXTRA,0,nil,Card.IsLinkSummonable)
		local b1=c26043006.fustg(e,op,eg,ep,ev,re,r,rp,0)
		local b2,b3,b4=#sg>0,#xg>0,#lg>0
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26043006,2))
		local opt=Duel.SelectEffect(op,
		{b1,aux.Stringid(26043006,3)},
		{b2 or b3 or b4,aux.Stringid(26043006,4)},
		{true,aux.Stringid(26043006,5)})
		if opt==1 then
			c26043006.fusop(e,op,eg,ep,ev,re,r,rp)
		elseif opt==2 then
			local exg=Group.CreateGroup()
			exg:Merge(sg);exg:Merge(xg);exg:Merge(lg);
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=exg:Select(op,1,1,nil):GetFirst()
			if sc:IsSynchroSummonable() then
				Duel.SynchroSummon(op,sc)
			elseif sc:IsXyzSummonable() then
				Duel.XyzSummon(op,sc)
			elseif sc:IsLinkSummonable() then
				Duel.LinkSummon(op,sc)
			end
		elseif opt==3 then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
c26043006.fustg=Fusion.SummonEffTG()
c26043006.fusop=Fusion.SummonEffOP()