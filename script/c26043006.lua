--Hetredox Warlock
function c26043006.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,26043002,26043003)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26043006,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetTarget(c26043006.rmtg)
	e3:SetOperation(c26043006.rmop)
	c:RegisterEffect(e3)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043006,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26043006.thtg)
	e2:SetOperation(c26043006.thop)
	c:RegisterEffect(e2)
end
function c26043006.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
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
		local fg=Duel.GetMatchingGroup(c26043006.ffilter,op,LOCATION_EXTRA,0,nil,tc)
		local sg=Duel.GetMatchingGroup(c26043006.exfilter,op,LOCATION_EXTRA,0,nil,Card.IsSynchroSummonable)
		local xg=Duel.GetMatchingGroup(c26043006.exfilter,op,LOCATION_EXTRA,0,nil,Card.IsXyzSummonable)
		local lg=Duel.GetMatchingGroup(c26043006.exfilter,op,LOCATION_EXTRA,0,nil,Card.IsLinkSummonable)
		local b2,b3,b4=#sg>0,#xg>0,#lg>0
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26043006,2))
		local opt=Duel.SelectEffect(op,
		{b2,aux.Stringid(26043006,4)},
		{b3,aux.Stringid(26043006,5)},
		{b4,aux.Stringid(26043006,6)},
		{true,aux.Stringid(26043006,7)})
		if opt==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(op,1,1,nil):GetFirst()
			Duel.SynchroSummon(op,sc)
		elseif opt==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xc=xg:Select(op,1,1,nil):GetFirst()
			Duel.XyzSummon(op,xc)
		elseif opt==3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local lc=lg:Select(op,1,1,nil):GetFirst()
			Duel.LinkSummon(op,lc)
		elseif opt==4 then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c26043006.ffilter(c,tc)
	return c:IsFusionSummonableCard() and tc:IsCanBeFusionMaterial(c)
end
function c26043006.thfilter(c,tc)
	return c:IsCode(table.unpack(tc.material)) and c:IsAbleToHand()
end
function c26043006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c26043006.thfilter,tp,LOCATION_REMOVED,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26043006.thfilter,tp,LOCATION_REMOVED,0,1,2,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c26043006.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
