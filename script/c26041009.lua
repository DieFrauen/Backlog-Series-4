--Xadres Pioneer
function c26041009.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c26041009.settg)
	e1:SetOperation(c26041009.setop)
	c:RegisterEffect(e1)
	
end
function c26041009.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and #g1>0 end
end
function c26041009.filter(c)
	return c:IsSetCard(0x641) and c:IsAbleToHand()
end
function c26041009.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SSet(tp,tc,tp,false)~=0 and Duel.IsExistingMatchingCard(c26041009.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(26041009,1)) then
		local g=Duel.SelectMatchingCard(tp,c26041009.filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
