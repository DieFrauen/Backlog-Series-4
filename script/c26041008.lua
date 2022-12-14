--Xadres Knight
function c26041008.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c26041008.settg)
	e1:SetOperation(c26041008.setop)
	c:RegisterEffect(e1)
	
end

function c26041008.filter(c)
	return c:IsCode(26041005) and c:IsSSetable(true)
end
function c26041008.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)
	local g2=Duel.GetMatchingGroup(c26041008.filter,tp,LOCATION_DECK,0,nil)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and #g1>0 end
end
function c26041008.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)
	local g2=Duel.GetMatchingGroup(c26041008.filter,tp,LOCATION_DECK,0,nil)
	local seq=c:GetSequence()
	if c:IsRelateToEffect(e) then g1:Merge(g2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc,tp,false)
		g1:RemoveCard(tc)
		if tc:GetPreviousLocation()==LOCATION_DECK then
			Duel.ConfirmCards(1-tp,tc)
		end
		local seq1=tc:GetSequence()
		local seq2=c:GetSequence()
		if seq2==5 then seq2=1
		elseif seq2==6 then seq2=3 end
		if c:IsRelateToEffect(e)
		and seq1<=4
		and (seq1==(seq2+2) or seq1==(seq2-2)) then
			Duel.Hint(HINT_CARD,tp,26041008)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(2)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end