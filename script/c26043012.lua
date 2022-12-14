--Hetredoxy
function c26043012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043012,0))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26043012)
	e2:SetTarget(c26043012.target)
	e2:SetOperation(c26043012.operation)
	c:RegisterEffect(e2)
	
end
function c26043012.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26043012.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26043012,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local cg=Duel.SelectMatchingCard(tp,c26043012.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
		if #cg==0 then return end
		Duel.ConfirmCards(1-tp,cg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26043012.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,cg:GetFirst())
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		end
	end
end
function c26043012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c26043012.filter1,tp,LOCATION_EXTRA,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
end
function c26043012.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26043012.filter1,tp,LOCATION_EXTRA,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local cg=sg1:Select(1-tp,1,1,nil)
		local cc=cg:GetFirst()
		Duel.Hint(HINT_CARD,tp,cc:GetCode())
		local thg=Duel.GetMatchingGroup(c26043012.filter2,tp,LOCATION_DECK,0,nil,cc)
		local nsg=Duel.GetMatchingGroup(c26043012.filter3,tp,LOCATION_HAND,0,nil,cc)
		local ops,opval,off={},{},1
		if #thg>0 then
			ops[off]=aux.Stringid(26043012,0)
			opval[off-1]=1
			off=off+1
		end
		if #nsg>0 then
			ops[off]=aux.Stringid(26043012,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			local sg=thg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		if opval[op]==2 then
			local sg=nsg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function c26043012.filter1(c,tp)
	return c.material and c:IsType(TYPE_FUSION) and not c:IsPublic()
end
function c26043012.filter2(c,fc)
	if c:IsForbidden() or not c:IsAbleToHand() then return false end
	return c:IsCode(table.unpack(fc.material))
end
function c26043012.filter3(c,fc)
	if c:IsForbidden() or not c:IsSummonable(true,nil) then return false end
	return c:IsCode(table.unpack(fc.material))
end