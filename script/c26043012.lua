--Hetredoxy
function c26043012.initial_effect(c)
	c:SetUniqueOnField(1,0,26043012)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043012,2))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c26043012.target)
	e2:SetOperation(c26043012.operation)
	c:RegisterEffect(e2)
	if not c26043012.global_check then
		c26043012.global_check=true
		c26043012[0]=nil
	end
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c26043012.handcon)
	c:RegisterEffect(e3)
end
function c26043012.handcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c26043012.hate,tp,0,LOCATION_MZONE,1,nil)
end
function c26043012.hate(c)
	local mat=c:GetMaterial()
	return c:GetType()&TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK ~=0 and mat and not mat:IsExists(c26043012.hcode,1,c,c)
end
function c26043012.hcode(c,rc)
	return rc:ListsCodeAsMaterial(c:GetCode())
end
function c26043012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
		return #tg>2
	end
end
function c26043012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 then return end
	Duel.ShuffleExtra(tp)
	Duel.ConfirmExtratop(tp,3)
	local tg=Duel.GetExtraTopGroup(tp,3)
	if tg:FilterCount(Card.IsType,nil,TYPE_FUSION)<3 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_CARD,tp,tc:GetCode())
	local thg=Duel.GetMatchingGroup(c26043012.filter2,tp,LOCATION_DECK,0,nil,tc)
	local nsg=Duel.GetMatchingGroup(c26043012.filter3,tp,LOCATION_HAND,0,nil,tc)
	local p1=#thg>0
	local p2=#nsg>0
	c26043012[0]=tc
	local p3=c26043012.fustg(e,tp,eg,ep,ev,re,r,rp,0)
	c26043012[0]=nil
	if (p1 or p2) and Duel.SelectYesNo(tp,aux.Stringid(26043012,0)) then
		local op=Duel.SelectEffect(tp,
		{p1,aux.Stringid(26043012,1)},
		{p2,aux.Stringid(26043012,2)},
		{p3,aux.Stringid(26043012,3)})
		if op==1 then
			local sg=thg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		if op==2 then
			local sg=nsg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.Summon(tp,tc,true,nil)
		end
		if op==3 then
			c26043012[0]=tc
			c26043012.fusop(e,tp,eg,ep,ev,re,r,rp)
			c26043012[0]=nil
		end
	end
end
function c26043012.filter1(c)
	return c.material and c:IsType(TYPE_FUSION)
end
function c26043012.filter2(c,fc)
	if c:IsForbidden() or not c:IsAbleToHand() then return false end
	return c:IsCode(table.unpack(fc.material))
end
function c26043012.filter3(c,fc)
	if c:IsForbidden() or not c:IsSummonable(true,nil) then return false end
	return c:IsCode(table.unpack(fc.material))
end
function c26043012.filter4(c,fc)
	return c:IsCode(table.unpack(fc.material))
end
function c26043012.fuscheck(tp,sg,fc)
	return sg:IsExists(aux.FilterBoolFunction(c26043012.filter4,fc,fc,SUMMON_TYPE_FUSION,tp),#sg,nil) and fc==c26043012[0]
end
function c26043012.fusextra(e,tp,mg)
	return nil,c26043012.fuscheck
end
function c26043012.fusfilter(c)
	return c:IsCode(e:GetLabel())
end
c26043012.fustg=Fusion.SummonEffTG(nil,nil,c26043012.fusextra)
c26043012.fusop=Fusion.SummonEffOP(nil,nil,c26043012.fusextra)