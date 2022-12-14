--Pulse of Meggidon
function c26042009.initial_effect(c)
	if not c26042009.global_check then
		c26042009.global_check=true
		c26042009[0]=false
		c26042009[1]=false
		c26042009[2]=false
		c26042009[3]=false
		c26042009[4]=false
		c26042009[5]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetLabel(0)
		ge1:SetCondition(c26042009.check1)
		ge1:SetOperation(c26042009.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_GRAVE)
		ge2:SetLabel(2)
		ge2:SetCondition(c26042009.check2)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetLabel(4)
		ge3:SetCondition(c26042009.check3)
		Duel.RegisterEffect(ge3,0)
	end
	--whew
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26042009.target)
	e1:SetOperation(c26042009.activate)
	c:RegisterEffect(e1)
end
function c26042009.checkg1(c)
	return c:GetPreviousLocation()==LOCATION_DECK and not c:IsReason(REASON_DRAW)
end
function c26042009.checkg2(c)
	return c:GetPreviousLocation()==LOCATION_DECK 
end
function c26042009.check1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042009.checkg1,nil)
	return g>0
end
function c26042009.check2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042009.checkg2,nil)
	return re and re:GetCategory()&CATEGORY_DECKDES ==0 and g>0
end
function c26042009.check3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterCount(c26042009.checkg2,nil)
	return g>0
end
function c26042009.checkop(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabel()
	if c26042009[lab+rp]==false then 
		c26042009[lab+rp]=true
		local str=3
		if lab>=2 then str=4 end
		if lab>=4 then str=5 end
	end
end
function c26042009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cond=0
	if c26042009[1-tp] then cond=cond+1 end
	if c26042009[3-tp] then cond=cond+1 end
	if c26042009[5-tp] then cond=cond+1 end
	if c26042009[tp] or c26042009[tp+2] or c26042009[tp+4] then cond=0 end 
	if chk==0 then return cond>0 and Duel.IsPlayerCanDiscardDeck(tp,cond) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,cond)
end
function c26042009.gyfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x642)
end
function c26042009.ritfilter(c)
	return c:GetType()==TYPE_SPELL+TYPE_RITUAL and not c:IsPublic() and c:CheckActivateEffect(true,true,false)~=nil
end
function c26042009.activate(e,tp,eg,ep,ev,re,r,rp)
	local cond,sg=0,0
	if c26042009[1-tp] then cond=cond+1 end
	if c26042009[3-tp] then cond=cond+1 end
	if c26042009[5-tp] then cond=cond+1 end
	if c26042009[tp] or c26042009[tp+2] or c26042009[tp+4] then cond=0 end 
	Duel.DiscardDeck(tp,cond,REASON_EFFECT)
	local g1=Duel.GetMatchingGroup(c26042009.gyfilter,tp,LOCATION_GRAVE,0,nil)
	if cond>=2 and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(26042009,1)) then
		Duel.BreakEffect()
		sg=g1:Select(tp,1,cond-1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		local g2=Duel.GetMatchingGroup(c26042009.ritfilter,tp,LOCATION_HAND,0,nil)
		if cond==3 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(26042009,2)) then
			Duel.BreakEffect()
			local sg=g2:Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tp,sg)
			local op=sg:GetFirst():CheckActivateEffect(true,true,false):GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
