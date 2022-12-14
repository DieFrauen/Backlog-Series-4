--Xadres Rook
function c26041006.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c26041006.settg)
	e1:SetOperation(c26041006.setop)
	c:RegisterEffect(e1)
	
end
function c26041006.filter(c)
	return c:IsCode(26041003) and c:IsSSetable(true)
end
function c26041006.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)
	local g2=Duel.GetMatchingGroup(c26041006.filter,tp,LOCATION_DECK,0,nil)
	local seq=e:GetHandler():GetSequence()
	if seq==0 or seq==4 then g1:Merge(g2) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and #g1>0 end
end
function c26041006.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)
	local g2=Duel.GetMatchingGroup(c26041006.filter,tp,LOCATION_DECK,0,nil)
	local seq=c:GetSequence()
	if (seq==0 or seq==4) and c:IsRelateToEffect(e) then g1:Merge(g2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc,tp,false)
		if tc:GetPreviousLocation()==LOCATION_DECK then
			Duel.ConfirmCards(1-tp,tc)
		end
		if c:GetColumnGroup():IsContains(tc) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
