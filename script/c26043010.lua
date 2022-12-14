--Hetredominion
function c26043010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26043010.cost)
	e1:SetTarget(c26043010.target)
	e1:SetOperation(c26043010.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_HAND,0)
	e2:SetValue(c26043010.matfilter)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26043010,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c26043010.thtg1)
	e3:SetOperation(c26043010.thop1)
	c:RegisterEffect(e3)
	--search
	local e3a=e3:Clone()
	e3a:SetDescription(aux.Stringid(26043010,3))
	e3a:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3a:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3a:SetTarget(c26043010.thtg2)
	e3a:SetOperation(c26043010.thop2)
	c:RegisterEffect(e3a)
	
end
c26043010.listed_series={0x643}
function c26043010.matfilter(e,c)
	if not c then return false end
	return not Duel.IsExistingMatchingCard(c26043010.filtermat,e:GetHandlerPlayer(),0xff,0xff,1,nil,c)
end
function c26043010.filtermat(c,fc)
	return fc:ListsCodeAsMaterial(c:GetCode()) or fc:ListsCode(c:GetCode())
end
function c26043010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(e)
	e1:SetTarget(c26043010.matfilter)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(26043010,1),nil)
end
function c26043010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26043010.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c26043010.filter1(c,lab)
	return c:IsAbleToHand() and
		((c:IsSetCard(0x643) and not c:IsCode(26043010) and lab==0) or
		(c:IsCode(CARD_POLYMERIZATION)) and lab==1)
end
function c26043010.filter2(c,lab)
	return c:IsAbleToGrave() and 
		((c:IsSetCard(0x643) and not c:IsCode(26043010) and lab==0) or
		(c:IsCode(CARD_POLYMERIZATION)) and lab==1)
end
function c26043010.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c26043010.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26043010.filter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,0) and (Duel.IsExistingMatchingCard(c26043010.filter2,tp,LOCATION_HAND,0,1,nil,1) or e:GetHandler():IsAbleToGrave()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26043010.filter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c26043010.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c26043010.filter2,tp,LOCATION_HAND,0,nil,1)
		sg:AddCard(e:GetHandler())
		local sc=sg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sc,REASON_EFFECT)
	end
end

function c26043010.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26043010.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,1) and (Duel.IsExistingMatchingCard(c26043010.filter2,tp,LOCATION_HAND,0,1,nil,0) or e:GetHandler():IsAbleToGrave()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,1)
end
function c26043010.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26043010.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,1)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(c26043010.filter2,tp,LOCATION_HAND,0,nil,0)
	sg:AddCard(e:GetHandler())
	local sc=sg:Select(tp,1,1,nil)
	Duel.SendtoGrave(sc,REASON_EFFECT)
end