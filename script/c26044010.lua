--Regiamorphosis Spread
function c26044010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26044010.target)
	e1:SetOperation(c26044010.activate)
	c:RegisterEffect(e1)
end
function c26044010.thfilter(c,lv)
	return c:IsMonster() and c:IsSetCard(0x644) and c:IsLevel(1) and c:IsAbleToHand()
end
function c26044010.ffilter(c,tp)
	return c:IsCode(26044009) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26044010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045)
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(Card.IsFaceup,nil)
		ct=ct+#g
		if ct>10 then ct=10 end
		return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=(ct)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26044010.activate(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local fg=Duel.GetMatchingGroup(c26044010.ffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	local tc=g:GetFirst()
	local lv=0
	for tc in aux.Next(g) do
		tc:AddCounter(0x1045,1)
	end
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1045)
	ct=math.min(10,math.floor(ct/2))
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.ConfirmDecktop(tp,ct)
	local dg=Duel.GetDecktopGroup(tp,ct)
	local mg=dg:Filter(c26044010.thfilter,nil,ct)
	fg2=dg:Filter(c26044010.ffilter,nil,tp)
	fg:Merge(fg2)
	local ct1=#mg>0
	local ct2=#fg>0
	if not (ct1 or ct2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26044010,0))
	local opt=Duel.SelectEffect(tp,
		{ct1,aux.Stringid(26044010,1)},
		{ct2,aux.Stringid(26044010,2)})
	if opt==1 then 
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,1,10,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		if ct>#sg then ct=#sg end
		if ct>0 then
			Duel.DiscardHand(tp,nil,ct,ct,REASON_EFFECT+REASON_DISCARD)
		end
	elseif opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=fg:Select(tp,1,1,nil):GetFirst()
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
		Duel.ShuffleDeck(tp)
	end
end